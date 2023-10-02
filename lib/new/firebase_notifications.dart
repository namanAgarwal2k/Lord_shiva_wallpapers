import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shiv_wallpaper/main.dart';

import 'notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('data: ${message.data['imageUrl']}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  if (message.data['imageUrl'] != null) {
    navigatorKey.currentState!.canPop()
        ? navigatorKey.currentState?.popAndPushNamed(NotificationScreen.route,
            arguments: message.data['imageUrl'])
        : navigatorKey.currentState?.pushNamed(NotificationScreen.route,
            arguments: message.data['imageUrl']);
  }
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
  FirebaseMessaging.onMessage.listen((message) {
    LocalNotificationService.createAndDisplayNotification(message);
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
  });
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // final _androidChannel = const AndroidNotificationChannel(
  //   'high_importance_channel',
  //   'High Importance Notifications',
  //   description: 'This channel is used for important notifications',
  //   importance: Importance.defaultImportance,
  // );
  // final _localNotifications = FlutterLocalNotificationsPlugin();

  // Future initLocalNotifications() async {
  //   const iOS = IOSInitializationSettings();
  //   const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const settings = InitializationSettings();
  //
  // }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:$fCMToken');
    initPushNotifications();
    LocalNotificationService.initializeLocal();
  }
}

class LocalNotificationService {
  // inside  class create instance of FlutterLocalNotificationsPlugin see below

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // after this create a method initialize to initialize localnotification

  static void initializeLocal() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_notification"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? imageUrl) async {
        print("onSelectNotification");
        if (imageUrl != null && imageUrl.isNotEmpty) {
          print("Router Value1234 $imageUrl");

          navigatorKey.currentState!.canPop()
              ? navigatorKey.currentState?.popAndPushNamed(
                  NotificationScreen.route,
                  arguments: imageUrl)
              : navigatorKey.currentState
                  ?.pushNamed(NotificationScreen.route, arguments: imageUrl);
        }
      },
    );
  }

  // after initialize we create channel in createAndDisplayNotification method

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "push_notification_app",
          "push_notification_app",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['imageUrl'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
