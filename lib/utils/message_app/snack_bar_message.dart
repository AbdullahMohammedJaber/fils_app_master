import 'package:flutter/material.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

showSnackBarMessage(
  BuildContext context, {
  required MessageType messageType,
  required String message,
  Widget? buildItem,
  String? titleAction,
  Function()? onPress,
  SnackBarBehavior? snackBarBehavior,
  Function? onVisible,
  bool showCloseIcon = false,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: buildItem ??
          DefaultText(
            message,
            color: white,
            type: FontType.medium,
            fontSize: 14,
          ),
      backgroundColor:
          messageType == MessageType.Success ? Colors.green : Colors.red,
      action: SnackBarAction(
        label: titleAction ?? "",
        onPressed: onPress ?? () {},
      ),
      behavior: snackBarBehavior ?? SnackBarBehavior.floating,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      duration: const Duration(seconds: 3),
      elevation: 1,
      onVisible: onVisible!(),
      showCloseIcon: showCloseIcon,
      closeIconColor: white,
      dismissDirection: DismissDirection.down,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    ),
  );
}
