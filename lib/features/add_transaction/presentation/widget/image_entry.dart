import 'dart:io';

import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ImageEntry extends StatelessWidget {
  final double h, w;
  final File? selectedImage;
  final bool isUploading;
  final VoidCallback onSelectImage;
  final VoidCallback? onUpload;

  const ImageEntry({
    super.key,
    required this.h,
    required this.w,
    required this.selectedImage,
    required this.isUploading,
    required this.onSelectImage,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: h * 0.4,
          width: w,
          decoration: BoxDecoration(
            color: AppColors.widget,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: selectedImage != null
                ? Image.file(selectedImage!, fit: BoxFit.cover)
                : Center(
                    child: Image.asset(
                      'assets/images/image_entry.png',
                      width: w,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        SizedBox(height: h * 0.02),
        Text(
          selectedImage != null
              ? 'Ready to upload'
              : 'Pick an image to upload as transaction proof',
          style: AppTextStyles.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: h * 0.02),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isUploading ? null : onSelectImage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.main),
                  foregroundColor: AppColors.main,
                ),
                child: const Text('Select Image'),
              ),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: ElevatedButton(
                onPressed: isUploading ? null : onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                ),
                child: isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : const Text('Upload Image'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
