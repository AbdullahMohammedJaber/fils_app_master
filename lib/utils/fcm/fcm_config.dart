import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fils/utils/fcm/push_notfi.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/storage/storage.dart';

import '../const.dart';

firebaseMessagingIni() async {
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestNotificationsPermission();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();

  setFcmToken(token!);

  pluginIni();
  startFCMlisten();
  printGreen("FcmToken : $token");
}

startFCMlisten() async {
  FirebaseMessaging.instance.subscribeToTopic("fils");

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    onSelectNotification(
      NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        payload: jsonEncode(initialMessage.data),
      ),
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data.isNotEmpty) {
      onSilent(jsonEncode(message.data));
    }

    if (message.notification != null) {
      showNotification(
        0,
        message.notification!.title,
        message.notification!.body,
        jsonEncode(message.data),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //showNotification(0, message.notification.title,  message.notification.body,jsonEncode(message.data));
    // showCustomFlash(text: message.data.toString());
    onSelectNotification(
      NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        payload: jsonEncode(message.data),
      ),
    );
  });
}
