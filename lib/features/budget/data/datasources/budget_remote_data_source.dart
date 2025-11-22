import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetRemoteDataSource {
  final FirebaseFirestore firestore;
  BudgetRemoteDataSource(this.firestore);

  Future<void> addBudget(String uid, BudgetModel model) async {
    final data = model.toFirestore(uid: uid);

    await firestore
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .add(data);

    // final ref = firestore
    //     .collection('users')
    //     .doc(uid)
    //     .collection('budgets')
    //     .doc();

    // final newModel = model.copyWith(id: ref.id);

    // await ref.set(newModel.toFirestore());
  }

  Future<List<BudgetModel>> getBudgets(String uid) async {
    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .get();

    return snap.docs.map((d) => BudgetModel.fromFirestore(d)).toList();
  }

  Future<void> updateBudget(String uid, BudgetModel model) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc(model.id)
        .update(model.toFirestore());
  }

  Future<void> deleteBudget(String uid, String budgetId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('budgets')
        .doc(budgetId)
        .delete();
  }
}
