import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AddTxRemoteDataSource {
  Future<String> saveTransaction(TransactionModel model);
  Future<void> deleteTransactionWithBalance({
    required String id,
    required String moneySourceId,
    required double amount,
    required bool isIncome,
  });
  Future<void> updateTransactionWithBalance({
    required TransactionModel oldModel,
    required TransactionModel newModel,
  });
  Future<void> updateBudgetsWithTransaction(TransactionModel model);
}

class AddTxRemoteDataSourceImpl implements AddTxRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AddTxRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<String> saveTransaction(TransactionModel model) async {
    // 1. Bắt buộc phải có user
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final uid = user.uid;

    // 2. Chuẩn bị json
    // final data = model.toJson(uid: uid);
    final data = model.toJson();

    // 3. Lưu đúng path users/{uid}/transactions/{autoId}
    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add(data);
    return doc.id;
  }

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<void> deleteTransactionWithBalance({
    required String id,
    required String moneySourceId,
    required double amount,
    required bool isIncome,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final uid = user.uid;

    final txRef = firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(id);
    final msRef = firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .doc(moneySourceId);

    await firestore.runTransaction((transaction) async {
      final msSnap = await transaction.get(msRef);
      if (!msSnap.exists) {
        throw Exception('Money source not found');
      }
      final currentBalance = (msSnap.data()?['balance'] ?? 0).toDouble();
      final delta = isIncome ? -amount : amount;
      final newBalance = currentBalance + delta;

      transaction.update(msRef, {'balance': newBalance});
      transaction.delete(txRef);
    });
  }

  @override
  Future<void> updateTransactionWithBalance({
    required TransactionModel oldModel,
    required TransactionModel newModel,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final uid = user.uid;

    if (oldModel.id == null || oldModel.id!.isEmpty) {
      throw Exception('Transaction ID missing');
    }

    final txRef = firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(oldModel.id);

    final oldMsRef = firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .doc(oldModel.moneySourceId);
    final newMsRef = firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .doc(newModel.moneySourceId);

    await firestore.runTransaction((transaction) async {
      // update transaction doc
      transaction.update(txRef, newModel.toJson());

      // revert old effect
      final revert = oldModel.isIncome ? -oldModel.amount : oldModel.amount;
      // apply new effect
      final apply = newModel.isIncome ? newModel.amount : -newModel.amount;

      if (oldModel.moneySourceId == newModel.moneySourceId) {
        transaction.update(newMsRef, {
          'balance': FieldValue.increment(revert + apply),
        });
      } else {
        transaction.update(oldMsRef, {'balance': FieldValue.increment(revert)});
        transaction.update(newMsRef, {'balance': FieldValue.increment(apply)});
      }
    });
  }

  @override
  Future<void> updateBudgetsWithTransaction(TransactionModel model) async {
    if (model.isIncome) return;

    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final budgetsSnap = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .where('categoryId', isEqualTo: model.categoryId)
        .where('isActive', isEqualTo: true)
        .get();

    for (final doc in budgetsSnap.docs) {
      final data = doc.data();
      final rawSpent = data['spent'];

      double currentSpent;
      if (rawSpent is num) {
        currentSpent = rawSpent.toDouble();
      } else if (rawSpent is String) {
        currentSpent = double.tryParse(rawSpent) ?? 0;
      } else {
        currentSpent = 0;
      }

      final newSpent = currentSpent + model.amount;

      await doc.reference.update({'spent': newSpent});
    }
  }
}
