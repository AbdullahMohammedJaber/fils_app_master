// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fils/utils/storage/storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fils/utils/global_function/printer.dart';

import '../const.dart';

pluginIni() {
  var initializationSettingsAndroid = const AndroidInitializationSettings(
    '@drawable/logo_noti',
  );
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onSelectNotification,
    // onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse
  );

  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestNotificationsPermission();
  }
  print('initState2');
}

Future<void> showNotification(
  dynamic notificationId,
  String? notificationTitle,
  String? notificationContent,
  String payload, {
  String channelId = '123',
  String channelTitle = 'Android Channel',
  String channelDescription = 'Default Android Channel for notifications',
  Priority notificationPriority = Priority.high,
  Importance notificationImportance = Importance.max,
}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
    channelDescription: channelDescription,
    playSound: true,
    enableVibration: true,
    icon: '@drawable/logo_noti',
    colorized: true,

    largeIcon: const DrawableResourceAndroidBitmap('@drawable/logo_noti'),
    silent: isVibration(),
    importance: notificationImportance,
    priority: notificationPriority,
  );
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    presentSound: true,
  );

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

Future<dynamic> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  Map map =
      await jsonDecode(notificationResponse.payload!) as Map<String, dynamic>;
  dynamic id = double.parse(map['product_id'].toString());
  String type = map['notification_type_id'].toString();
  printGreen("type =======> $type");
  // type = 1 win auction
  // type = 33 place pid
  // type = 34 start auction
  // type = 35
  if (type == '1') {
  } else if (type == '2') {
  } else if (type == '4') {
  } else {}

  print('onSelectNotification $map');
}

Future<dynamic> onSilent(String payload) async {
  printGreen(payload);
  printGreen("Get Message In Notification ------------>");

  Map map = await jsonDecode(payload) as Map<String, dynamic>;
  // dynamic id = dynamic.parse(map['target_id'].toString()??'0');

  switch (map['msgType'].toString()) {
    case "2":
      print("Get Message In Notification ------------>");
      break;
  }

  print('onSelectNotification$payload');
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //showNotification(0, message.notification.title,  message.notification.body,jsonEncode(message.data));

  // onSelectNotification(jsonEncode(message.data));
  print(
    "Handling a background message: ${message.messageId}  ${message.data} ",
  );
}
