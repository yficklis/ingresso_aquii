import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ingresso_aquii/pages/hall_page.dart';
import 'package:ingresso_aquii/pages/my_tickets.dart';
import 'package:ingresso_aquii/pages/shopping_cart.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final items = <Widget>[
    const Icon(
      Icons.local_activity,
    ),
    const Icon(
      Icons.home,
    ),
    const Icon(
      Icons.shopping_cart,
    ),
  ];

  List<dynamic> currentPage = [
    const MyTickets(),
    const HallPage(),
    const ShoppingCart()
  ];

  int activePage = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple.shade200,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(
                color: Color(0xffFEFAFF),
              ),
            ),
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.deepPurple.shade200,
              height: 70,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 350),
              index: activePage,
              items: items,
              onTap: (index) => setState(() => activePage = index),
            ),
          ),
          appBar: CustomAppBar(),
          body: currentPage[activePage],
        ),
      ),
    );
  }
}
