import 'package:flutter/material.dart';

import 'product.dart';

class Shop extends ChangeNotifier {
  final List<Product> _productMenu = [
    Product(
      name: 'Ingresso',
      price: 12.90,
      imagePath: 'assets/images/cinema.png',
      subscription: 'Ingresso de cinema',
    ),
    Product(
      name: 'Combo Grande',
      price: 34.90,
      imagePath: 'assets/images/watching-a-movie.png',
      subscription: '1 Pipoca G e 1 Regrigerante G',
    ),
  ];

  // customer cart
  List<Product> _cart = [];

  // getter methods

  List<Product> get productMenu => _productMenu;
  List<Product> get cart => _cart;

  // add to cart
  void addToCart(Product productItem, int quantity) {
    for (int i = 0; i < quantity; i++) {
      _cart.add(productItem);
    }
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  // Get aggregated cart items with quantities
  List<Map<String, dynamic>> getCartWithQuantities() {
    Map<String, int> productQuantities = {};

    for (Product product in _cart) {
      if (productQuantities.containsKey(product.name)) {
        productQuantities[product.name] = productQuantities[product.name]! + 1;
      } else {
        productQuantities[product.name] = 1;
      }
    }

    List<Map<String, dynamic>> aggregatedCart = [];

    productQuantities.forEach((productName, quantity) {
      aggregatedCart.add({
        'product': productName,
        'quantity': quantity,
      });
    });

    return aggregatedCart;
  }
}
