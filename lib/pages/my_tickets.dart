import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Tickets Page - Signed is  Anonymous: ${user.isAnonymous}"),
      ),
    );
  }
}
