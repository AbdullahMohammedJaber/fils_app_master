// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';

import '../../../../widget/defulat_text.dart';

bool delete = false;

showDialogDeleteCart(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const ScaleTransitionDialog();
    },
  );
}

class ScaleTransitionDialog extends StatefulWidget {
  const ScaleTransitionDialog({super.key});

  @override
  _ScaleTransitionDialogState createState() => _ScaleTransitionDialogState();
}

class _ScaleTransitionDialogState extends State<ScaleTransitionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    delete = false;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            DefaultText(
              'Delete Cart Item'.tr(),
              type: FontType.bold,
              fontSize: 20,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                delete = false;
                Navigator.pop(context, delete);
              },
            ),
          ],
        ),
        content: DefaultText(
          'Are you sure you want to remove the item from the cart?'.tr(),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                    title: "Yes".tr(),
                    onTap: () {
                      delete = true;
                      Navigator.pop(context, delete);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                    title: "No".tr(),
                    colorButton: blackColor,
                    onTap: () {
                      delete = false;
                      Navigator.pop(context, delete);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
