import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = "/notification_screen";
  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: Center(
          child: message != null
              ? Column(
                  children: [
                    Text('${message.notification?.title}'),
                    Text('${message.notification?.body}'),
                    Text('${message.data}'),
                  ],
                )
              : Text('No new notification'),
        ),
      ),
    );
  }
}
