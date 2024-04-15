import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  CustomNavBar({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        color: Theme.of(context).colorScheme.inversePrimary,
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: Color(0xff6003A2),
        tabBackgroundColor: Color(0xffFEFAFF),
        tabBorderRadius: 24,
        tabActiveBorder: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        gap: 5,
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Início',
          ),
          GButton(
            icon: Icons.shopping_bag_outlined,
            text: 'Carrinho',
          )
        ],
      ),
    );
  }
}
