import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shiv_wallpaper/main.dart';

import 'notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('data: ${message.data}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  navigatorKey.currentState!.canPop()
      ? navigatorKey.currentState
          ?.popAndPushNamed(NotificationScreen.route, arguments: message)
      : navigatorKey.currentState
          ?.pushNamed(NotificationScreen.route, arguments: message);
}

//for apple
Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    sound: true,
    badge: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  //   FirebaseMessaging.onMessage.listen((message) {
  //     final notification = message.notification;
  //     if (notification == null) return;
  //
  //     _localNotifications.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           _androidChannel.id,
  //           _androidChannel.name,
  //           channelDescription: _androidChannel.description,
  //           icon: '@drawable/ic_launcher',
  //         ),
  //       ),
  //       payload: jsonEncode(message.toMap()),
  //     );
  //   });
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  //
  // Future initLocalNotifications() async {
  //   const iOS = IOSInitializationSettings();
  //   const android = AndroidInitializationSettings('@drawable/ic_launcher');
  //   const settings = InitializationSettings('@drawable/ic_launcher');
  //
  // }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:$fCMToken');
    initPushNotifications();
  }
}
