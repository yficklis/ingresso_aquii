import 'package:flutter/material.dart';

import 'product.dart';

class Shop extends ChangeNotifier {
  final List<Product> _productMenu = [
    Product(
      id: '01',
      name: 'Ingresso',
      price: 12.90,
      imagePath: 'assets/images/cinema.png',
      subscription: 'Ingresso de cinema',
      quantity: 0,
    ),
    Product(
      id: '02',
      name: 'Combo Grande',
      price: 34.90,
      imagePath: 'assets/images/watching-a-movie.png',
      subscription: '1 Pipoca G e 1 Regrigerante G',
      quantity: 0,
    ),
  ];

  // customer cart
  List<Product> _cart = [];

  // getter methods

  List<Product> get productMenu => _productMenu;
  List<Product> get cart => _cart;

  // add to cart
  void addToCart(Product productItem, int quantity) {
    if (!_cart.contains(productItem)) {
      productItem.quantity = quantity;
      _cart.add(productItem);
      return;
    }

    _cart.forEach((element) {
      if (element.id == productItem.id) {
        print("QUANTIDADE ATUAL ---> ${element.quantity} <--");

        element.quantity += quantity;
        print(
          "${element.id} - ${element.name} - ${element.price} - ${element.quantity}",
        );
      }
    });
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}
