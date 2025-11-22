import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/money_source_model.dart';

class MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;

  MoneySourceRemoteDataSource(this.firestore);

  Future<List<MoneySourceModel>> getMoneySources(String uid) async {
    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('money_sources')
        .get();

    return snap.docs.map((d) => MoneySourceModel.fromFirestore(d)).toList();
  }
}
