import 'package:flutter/material.dart';
import 'package:ingresso_aquii/pages/home_page.dart';
import 'package:ingresso_aquii/pages/sign_in/sign_in_page.dart';
import 'package:ingresso_aquii/pages/sign_up/sign_up_page.dart';
import 'package:ingresso_aquii/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff13001F),
          scaffoldBackgroundColor: const Color(0xffFEFAFF),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/homepage': (context) => const HomePage(),
          '/signin': (context) => SignInPage(),
          '/signup': (context) => const SignUpPage(),
        });
  }
}
