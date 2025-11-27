import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/money_source_entity.dart';

abstract class MoneySourceRemoteDataSource {
  Future<List<MoneySourceEntity>> getMoneySources(String uid);
  Future<void> addMoneySource(String uid, MoneySourceEntity entity);
  Future<void> updateMoneySource(String uid, MoneySourceEntity entity);
  Future<void> deleteMoneySource(String uid, String id);
  Future<bool> hasMoneySources(String uid);
}

class MoneySourceRemoteDataSourceImpl implements MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  MoneySourceRemoteDataSourceImpl(this.firestore, this.auth);

  CollectionReference getCollection(String uid) =>
      firestore.collection('users').doc(uid).collection('money_sources');

  @override
  Future<void> addMoneySource(String uid, MoneySourceEntity entity) async {
    final docRef = await getCollection(uid).add(entity.toJson());
    await docRef.update({'id': docRef.id});
  }

  @override
  Future<void> updateMoneySource(String uid, MoneySourceEntity entity) async {
    await getCollection(uid).doc(entity.id).update(entity.toJson());
  }

  @override
  Future<void> deleteMoneySource(String uid, String id) async {
    await getCollection(uid).doc(id).delete();
  }

  @override
  Future<List<MoneySourceEntity>> getMoneySources(String uid) async {
    final snapshot = await getCollection(uid).get();
    return snapshot.docs
        .map(
          (doc) => MoneySourceEntity(
            id: doc.id,
            name: doc['name'],
            icon: doc['icon'],
            balance: (doc['balance'] as num).toDouble(),
          ),
        )
        .toList();
  }

  @override
  Future<bool> hasMoneySources(String uid) async {
    final snapshot = await getCollection(uid).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}
