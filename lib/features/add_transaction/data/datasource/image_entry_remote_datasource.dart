import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

abstract class ImageEntryRemoteDataSource {
  Future<TransactionModel> uploadImage({
    required File image,
    required String userId,
    required List<Map<String, String>> moneySources,
  });

  Future<void> syncIsIncomeIfNeeded(TransactionEntity tx);
}

class ImageEntryRemoteDataSourceImpl implements ImageEntryRemoteDataSource {
  final Dio dio;
  final String webhookUrl;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ImageEntryRemoteDataSourceImpl({
    required this.dio,
    required this.webhookUrl,
    required this.firestore,
    required this.auth,
  });

  @override
  Future<TransactionModel> uploadImage({
    required File image,
    required String userId,
    required List<Map<String, String>> moneySources,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: basename(image.path),
        ),
        'userId': userId,
        'moneySources': jsonEncode(moneySources),
      });

      final response = await dio.post(
        webhookUrl,
        data: formData,
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return TransactionModel.fromN8nJson(data);
        } else if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map<String, dynamic>) {
            return TransactionModel.fromN8nJson(
              Map<String, dynamic>.from(first),
            );
          }
        }
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }

      throw Exception(
        'Upload failed (${response.statusCode ?? 'no status'}): ${response.data}',
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? -1;
      final data = e.response?.data ?? e.message ?? 'Unknown Dio error';
      throw Exception('Upload failed ($status): $data');
    }
  }

  @override
  Future<void> syncIsIncomeIfNeeded(TransactionEntity tx) async {
    final user = auth.currentUser;
    final txId = tx.id;

    if (user == null || txId == null || txId.isEmpty) {
      return;
    }

    final docRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(txId);

    final doc = await docRef.get();
    final data = doc.data();

    if (data == null) return;

    final isIncomeField = data['isIncome'];
    if (isIncomeField == null) {
      await docRef.update({'isIncome': tx.isIncome});
    }
  }
}
