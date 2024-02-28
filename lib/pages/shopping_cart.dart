import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/product_tile_cart.dart';
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
              const Text(
                "Seu carrinho",
                style: TextStyle(
                  color: Color(0xff260145),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
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
                        'Seguir para o pagamento',
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
