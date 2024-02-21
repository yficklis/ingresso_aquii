import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HallPage extends StatefulWidget {
  const HallPage({super.key});

  @override
  State<HallPage> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Hall Page - Signed is Anonymous: ${user.isAnonymous}'),
        ]),
      ),
    );
  }
}
