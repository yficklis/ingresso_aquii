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
        element.quantity += quantity;
      }
    });
    notifyListeners();
  }

  // add from cart by one
  void addFromCartByOnce(String idProduct) {
    _cart.forEach((element) {
      if (element.id == idProduct) {
        element.quantity++;
      }
    });
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  // remove from cart by one
  void removeFromCartByOnce(String idProduct) {
    _cart.forEach((element) {
      if (element.id == idProduct && element.quantity > 1) {
        element.quantity--;
      }
    });
    notifyListeners();
  }

  // return total price
  double totalPriceIncart() {
    double valueTotal = 0;
    _cart.forEach((element) {
      valueTotal += (element.price * element.quantity);
    });
    return valueTotal;
  }

  String formatTotalPrice() {
    String price = this.totalPriceIncart().toStringAsFixed(2);
    return price.replaceAll('.', ',');
  }

  int getTotalItemForSale(String item) {
    String idSearch = (item == 'ingressos') ? '01' : '02';
    int totalQuantity = 0;
    _cart.forEach((element) {
      if (element.id == idSearch && element.quantity > 1) {
        totalQuantity = element.quantity;
      }
    });
    notifyListeners();
    return totalQuantity;
  }

  void deleteAllFromCart() {
    _cart = [];
    notifyListeners();
  }
}
