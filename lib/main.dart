import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:upgrader/upgrader.dart';
import 'new/firebase_notifications.dart';
import 'new/homepage.dart';
import 'new/notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ['A46371809673D36633BF23D110F015B4']));
  //working['5604DD3357FF120D29C049404A5F25B9']));
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const ProviderScope(child: OverlaySupport.global(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  internetChecker() async {
    bool internet = await InternetConnectionChecker().hasConnection;

    if (internet == true) {
      return true;
    } else {
      toast(
        'Check internet connection and restart the app :)',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.blue),
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            navigatorKey: navigatorKey,
            title: 'Lord Shiv HD New Wallpapers ',
            routes: {
              NotificationScreen.route: (context) => const NotificationScreen()
            },
            home: UpgradeAlert(
              showIgnore: false,
              child: FutureBuilder(
                  future: internetChecker(),
                  builder: (context, status) {
                    if (status.data == true) {
                      return const HomePage();
                    } else {
                      return const Center(
                        child: Card(
                          color: Colors.black,
                          child: Text(
                            ':::: JAI BHOLENATH :::',
                            style: TextStyle(
                                fontSize: 28,
                                letterSpacing: 2,
                                color: Colors.greenAccent),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          );
        });
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:overlay_support/overlay_support.dart';
// // import 'package:get/get.dart';
// //import 'admobile_service.dart';
// import 'home.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   MobileAds.instance.initialize;
//   // AdmobService.initialize();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   const MyApp({Key? key}) : super(key: key);
//   void initState() {
//     // super.initState();
//     // fetchApi();
//     internetChecker();
//   }
//
//   internetChecker() async {
//     bool internet = await InternetConnectionChecker().hasConnection;
//
//     if (internet == true) {
//       // fetchApi();
//       return true;
//     } else {
//       toast('Check internet connection and restart the app :)');
//       print('No internet :( Reason:');
//     }
//   }
//
//   static final ValueNotifier<ThemeMode> themeNotifier =
//       ValueNotifier(ThemeMode.light);
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: themeNotifier,
//         builder: (_, ThemeMode currentMode, __) {
//           return MaterialApp(
//             theme: ThemeData(primarySwatch: Colors.amber),
//             debugShowCheckedModeBanner: false,
//             darkTheme: ThemeData.dark(),
//             themeMode: currentMode,
//             title: 'Lord Shiv HD New Wallpapers ',
//             home: FutureBuilder(
//                 future: internetChecker(),
//                 builder: (context, status) {
//                   if (status.data == true) {
//                     return MyHomePage(
//                       title: 'Jai BholeNath',
//                     );
//                   } else {
//                     return Center(
//                         child: Card(
//                       color: Colors.black,
//                       child: Text(
//                         ':::: JAI BHOLENATH :::',
//                         style: TextStyle(
//                             fontSize: 28,
//                             letterSpacing: 2,
//                             color: Colors.greenAccent),
//                       ),
//                     ));
//                   }
//                 }),
//             //  ),
//           );
//         });
//   }
// }
