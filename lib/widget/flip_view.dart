import 'dart:math';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:provider/provider.dart';

class FlipView extends StatelessWidget {
  final Widget? child;

  const FlipView({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(getLocal() == 'en' ? 0 : pi),
      child: child,
    );
  }
}
