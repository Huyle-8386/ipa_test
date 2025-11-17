import 'package:flutter/material.dart';

class ImageEntry extends StatelessWidget {
  final double h, w;

  const ImageEntry({super.key, required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h * 0.6,
      width: w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Image.asset(
            'assets/images/image_entry.png',
            width: w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
