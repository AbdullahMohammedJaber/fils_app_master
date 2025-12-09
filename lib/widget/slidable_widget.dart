// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSlideAction extends StatelessWidget {
  final Color? color;
  final String? imagePath;

  final VoidCallback? onTap;

  const CustomSlideAction({
    super.key,
    required this.color,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: SvgPicture.asset(
          imagePath!,
          color: color,
        ),
      ),
    );
  }
}
