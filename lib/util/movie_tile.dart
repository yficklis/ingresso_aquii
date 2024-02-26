import 'package:flutter/material.dart';
import 'package:ingresso_aquii/models/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final void Function()? onPressed;
  final Widget icon;
  const MovieTile(
      {super.key,
      required this.movie,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 28.0),
        child: ListTile(
          title: Text(movie.name),
          subtitle: Text("R\$ ${movie.price}"),
          leading: Image.asset(movie.imagePath),
          trailing: IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
