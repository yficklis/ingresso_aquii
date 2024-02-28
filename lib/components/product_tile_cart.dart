import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:provider/provider.dart';

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
    void removeFromCartById(String id) {
      Provider.of<Shop>(context, listen: false).removeFromCartByOnce(id);
    }

    void addFromCartById(String id) {
      Provider.of<Shop>(context, listen: false).addFromCartByOnce(id);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 28.0),
        child: ListTile(
          title: Text(
            product.name,
            style: GoogleFonts.dmSerifDisplay(fontSize: 28),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "R\$ ${product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                children: [
                  // minus button
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff6003A2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => removeFromCartById(product.id),
                    ),
                  ),
                  //quantity count
                  SizedBox(
                    width: 28,
                    child: Center(
                      child: Text(
                        product.quantity.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  //plus button
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff6003A2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => addFromCartById(product.id),
                    ),
                  ),
                ],
              ),
            ],
          ),
          leading: Image.asset(product.imagePath),
          trailing: Column(
            children: [
              IconButton(
                icon: icon,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
