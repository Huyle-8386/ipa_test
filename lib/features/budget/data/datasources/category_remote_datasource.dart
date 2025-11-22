import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSource(this.firestore);

  Future<List<CategoryModel>> getCategories(bool isIncome) async {
    final snap = await firestore
        .collection('categories')
        .where('isIncome', isEqualTo: false)
        .get();

    return snap.docs.map((d) => CategoryModel.fromFirestore(d)).toList();
  }
}
