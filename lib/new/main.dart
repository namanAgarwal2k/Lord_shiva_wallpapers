import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



import 'fullscreen.dart';
import 'homepage.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child:  MyApp()));
}
final GoRouter _router = GoRouter(
    routes:<RouteBase> [
      GoRoute(path: '/',
      builder: (BuildContext context, GoRouterState state){
        return const HomePage();
      },
      routes:<RouteBase>[
        GoRoute(path: 'fullscreen',
          builder: (context, state){
          return  Fullscreen(url: state.extra.toString(),);
          }
        )
      ]
      )
    ]);




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    //  home: const HomePage(),
    );
  }
}
