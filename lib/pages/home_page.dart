import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ingresso_aquii/pages/onboarding_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () async => {
                await GoogleSignIn().signOut(),
                FirebaseAuth.instance.signOut(),
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const OnboardingPage(),
                    ),
                    (route) => false)
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Signed is as: ${user.isAnonymous}'),
          ]),
        ));
  }

  // Future signUserOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => const OnboardingPage(),
  //       ),
  //       (route) => false);
  // }
}
