import 'package:flutter/material.dart';
import 'package:ingresso_aquii/models/product.dart';

class ProductTileCart extends StatelessWidget {
  final Product product;
  final void Function()? onPressed;
  final Widget icon;
  const ProductTileCart({
    super.key,
    required this.product,
    required this.onPressed,
    required this.icon,
  });

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
          title: Text(product.name),
          subtitle: Text("R\$ ${product.price.toStringAsFixed(2)}"),
          leading: Image.asset(product.imagePath),
          trailing: IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
