import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/add_transaction/data/model/money_source_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

abstract class MoneySourceRemoteDataSource {
  Future<List<MoneySourceEntity>> getMoneySources(); // ✅
}

class MoneySourceRemoteDataSourceImpl implements MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;

  MoneySourceRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<MoneySourceEntity>> getMoneySources() async {
    final snap = await firestore.collection('money_sources').get();

    return snap.docs
        .map(
          (doc) => MoneySourceModel.fromFirestore(doc),
        ) // MoneySourceModel extends MoneySourceEntity
        .toList(); // nên List<MoneySourceEntity> OK
  }
}
