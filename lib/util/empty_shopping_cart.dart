import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyShoppingCart extends StatelessWidget {
  const EmptyShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/shopping.png',
            height: 140,
          ),
          Text(
            "Seu Carrinho está vazio!",
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 28,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
