import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = "/notification_screen";
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: Center(
          child: message != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Aaj ke DARSHAN',
                      style: TextStyle(
                          backgroundColor: Colors.white60,
                          fontSize: 24,
                          wordSpacing: 2,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.ideographic,
                          shadows: [Shadow(offset: Offset.fromDirection(11))],
                          color: Colors.red),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Image.network(
                        message.toString(),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                )
              : Text('No new notification'),
        ),
      ),
    );
  }
}
