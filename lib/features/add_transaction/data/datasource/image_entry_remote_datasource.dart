import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fintrack/features/add_transaction/data/model/transaction_model.dart';
import 'package:path/path.dart';

abstract class ImageEntryRemoteDataSource {
  Future<TransactionModel> uploadImage({
    required File image,
    required String userId,
    required List<Map<String, String>> moneySources,
  });
}

class ImageEntryRemoteDataSourceImpl implements ImageEntryRemoteDataSource {
  final Dio dio;
  final String webhookUrl;

  ImageEntryRemoteDataSourceImpl({required this.dio, required this.webhookUrl});

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
        throw Exception(
          'Unexpected response format: ${data.runtimeType}',
        );
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
}
