import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ingresso_aquii/models/movie.dart';
import 'package:ingresso_aquii/models/movie_shop.dart';
import 'package:ingresso_aquii/util/movie_tile.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final user = FirebaseAuth.instance.currentUser!;

  void removeFromCart(Movie movie) {
    Provider.of<MovieShop>(context, listen: false).removeItemFromCart(movie);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieShop>(
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
                  itemCount: value.userCart.length,
                  itemBuilder: (context, index) {
                    // get individual ticket
                    Movie eachMovie = value.userCart[index];

                    // return movie ticket tile
                    return MovieTile(
                      movie: eachMovie,
                      onPressed: () => removeFromCart(eachMovie),
                      icon: Icon(Icons.delete),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
