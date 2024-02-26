import 'package:flutter/material.dart';
import 'movie.dart';

class MovieShop extends ChangeNotifier {
  // movie ticket for sale list
  final List<Movie> _movieTicket = [
    // Combo ticket
    Movie(
      name: 'Combo Grande',
      price: '12,00',
      imagePath: "assets/images/watching-a-movie.png",
    ),
    Movie(
      name: 'Ingresso',
      price: '12,00',
      imagePath: "assets/images/cinema.png",
    ),
    // Ingresso ticket
  ];
  // user cart
  List<Movie> _userCart = [];

  // get movie ticket list
  List<Movie> get movieShop => _movieTicket;

  // get user cart
  List<Movie> get userCart => _userCart;

  // add item to cart
  void addItemToCart(Movie movie) {
    _userCart.add(movie);
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(Movie movie) {
    _userCart.remove(movie);
    notifyListeners();
  }
}
