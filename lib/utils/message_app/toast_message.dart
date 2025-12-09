import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/theme/color_manager.dart';

void showToastMessage(String message,
    {MessageType messageType = MessageType.Faild,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    dynamic durationInSec = 2}) {
  Fluttertoast.showToast(
    msg: message, // The message to display
    toastLength: Toast.LENGTH_SHORT, // Duration of the toast
    gravity: gravity, // Position of the toast (top, center, bottom)
    timeInSecForIosWeb: durationInSec, // Duration for iOS
    backgroundColor: messageType == MessageType.Success
        ? Colors.green
        : error, // Background color of the toast
    textColor: textColor, // Text color
    fontSize: 16.0, // Font size of the text
  );
}
