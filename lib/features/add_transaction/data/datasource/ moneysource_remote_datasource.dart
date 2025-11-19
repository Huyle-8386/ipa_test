import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/money_source_model.dart';

class MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;

  MoneySourceRemoteDataSource(this.firestore);

  Future<List<MoneySourceModel>> getMoneySources() async {
    final snap = await firestore.collection('money_sources').get();
    return snap.docs.map((d) => MoneySourceModel.fromFirestore(d)).toList();
  }
}
