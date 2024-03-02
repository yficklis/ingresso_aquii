import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ingresso_aquii/auth/auth_page.dart';
import 'package:ingresso_aquii/auth/delete/delete_account_page.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/pages/checkout_page.dart';
import 'package:ingresso_aquii/pages/how_to_use.dart';
import 'package:ingresso_aquii/pages/my_tickets.dart';
import 'package:ingresso_aquii/pages/shopping_cart.dart';
import 'package:ingresso_aquii/pages/suport_page.dart';
import 'package:ingresso_aquii/auth/update/update_password_page.dart';
import 'package:ingresso_aquii/auth/update/update_profile_page.dart';
import 'package:payment_client/payment_client.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ingresso_aquii/pages/home_page.dart';
import 'package:ingresso_aquii/auth/sign_in/sign_in_page.dart';
import 'package:ingresso_aquii/auth/sign_up/sign_up_page.dart';
import 'package:ingresso_aquii/pages/splash_screen.dart';
import 'package:provider/provider.dart';

final paymentClient = PaymentClient();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_test_51OFdVPF4ZPi532M06EJ4enR3zouzbVn2u1U8dxyTmrvrrAtQ7sv4rwIUKdJEMNZpGBYFFw2vME7imAPAZMO1Q7sE00tIpqBsnj';
  await Stripe.instance.applySettings();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
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
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/authpage': (context) => const AuthPage(),
          '/mytickets': (context) => const MyTickets(),
          '/shoppingcart': (context) => const ShoppingCart(),
          '/suportpage': (context) => const SuportPage(),
          '/updatepassword': (context) => const UpdatePasswordPage(),
          '/updateprofile': (context) => const UpdateProfilePage(),
          '/deleteaccount': (context) => const DeleteAccountPage(),
          '/howtousepage': (context) => const HowToUsePage(),
        });
  }
}
