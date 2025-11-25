import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fintrack/features/add_transaction/domain/entities/upload_image_result.dart';
import 'package:path/path.dart';

abstract class ImageEntryRemoteDataSource {
  Future<UploadImageResult> uploadImage({
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
  Future<UploadImageResult> uploadImage({
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

      return UploadImageResult(
        statusCode: response.statusCode ?? 0,
        data: response.data,
      );
    } on DioException catch (e) {
      return UploadImageResult(
        statusCode: e.response?.statusCode ?? -1,
        data: e.response?.data ?? e.message,
      );
    }
  }
}
