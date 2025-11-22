import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/money_source_entity.dart';
import '../models/money_source_model.dart';

abstract class MoneySourceRemoteDataSource {
  Future<List<MoneySourceEntity>> getMoneySources();
}

class MoneySourceRemoteDataSourceImpl implements MoneySourceRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  MoneySourceRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<List<MoneySourceEntity>> getMoneySources() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final snap = await firestore
        .collection("users")
        .doc(user.uid)
        .collection("money_sources")
        .get();

    print("🔥 Firestore returned ${snap.docs.length} documents");

    for (var d in snap.docs) {
      print("📄 Document: ${d.id} => ${d.data()}");
    }

    return snap.docs.map((doc) => MoneySourceModel.fromFirestore(doc)).toList();
  }
}
