import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ingresso_aquii/pages/hall_page.dart';
import 'package:ingresso_aquii/pages/shopping_cart.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/custom_drawer.dart';
import 'package:ingresso_aquii/util/custom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // navigate bottom bar
  int selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> currentPage = [
    // shop page
    HallPage(),

    // cart page
    ShoppingCart()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple.shade200,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: CustomNavBar(
            onTabChange: (index) => navigateBottomBar(index),
          ),
          appBar: CustomAppBar(
            title: '',
          ),
          drawer: CustomDrawer(),
          body: currentPage[selectedIndex],
        ),
      ),
    );
  }
}
