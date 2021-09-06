import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  void initState() {
    // super.initState();
    // fetchApi();
    internetChecker();
  }

  internetChecker() async {
    bool internet = await InternetConnectionChecker().hasConnection;

    if (internet == true) {
      // fetchApi();
      return true;
    } else {
      toast('Check internet connection and restart the app :)');
      print('No internet :( Reason:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        // accentColor: Colors.amber,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        // accentColor: Colors.amber,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lord Shiv HD New Wallpapers ',
        theme: theme,
        darkTheme: darkTheme,
        home: FutureBuilder(
            future: internetChecker(),
            builder: (context, status) {
              if (status.data == true) {
                return MyHomePage(
                  title: 'Jai BholeNath',
                );
              } else {
                return Center(
                    child: Card(
                  color: Colors.black,
                  child: Text(
                    '::: JAI BHOLENATH :::',
                    style: TextStyle(
                        fontSize: 28,
                        letterSpacing: 2,
                        color: Colors.greenAccent),
                  ),
                ));
              }
            }),
      ),
    );
  }
}
