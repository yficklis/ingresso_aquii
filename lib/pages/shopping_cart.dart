import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/util/empty_shopping_cart.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/components/product_tile_cart.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final user = FirebaseAuth.instance.currentUser!;
  void removeFromCart(Product product) {
    Provider.of<Shop>(context, listen: false).removeFromCart(product);
  }

  String getValueTotal() {
    return Provider.of<Shop>(context, listen: false).formatTotalPrice();
  }

  // pay button tapped
  void payNow() {
    /*
    
      fill out your payment service here
    
     */
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (value.cart.length == 0) EmptyShoppingCart(),
              if (value.cart.length > 0)
                Text(
                  "Seu carrinho",
                  style: GoogleFonts.dmSerifDisplay(fontSize: 28),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.cart.length,
                  itemBuilder: (context, index) {
                    // get individual ticket
                    Product eachProduct = value.cart[index];

                    // return movie ticket tile
                    return ProductTileCart(
                      product: eachProduct,
                      onPressed: () => removeFromCart(eachProduct),
                      icon: Icon(Icons.delete),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              if (value.cart.length > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // message
                    Text(
                      'Valor total:',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28,
                        color: Color(0xff363435),
                      ),
                    ),
                    Text(
                      '${getValueTotal()}',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28,
                        color: Color(0xff363435),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 25),
              // pay button
              if (value.cart.length > 0)
                GradientButton(
                  onPressed: () {
                    payNow();
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // text
                      Text(
                        'Prosseguir para pagamento',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
