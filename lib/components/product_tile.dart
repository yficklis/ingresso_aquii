import 'package:flutter/material.dart';
import 'package:ingresso_aquii/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;

  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffEADDFF),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 25),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Image.asset(
              product.imagePath,
              height: 140,
            ),

            // text
            Text(
              product.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),

            // price
            Flexible(
              child: SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: 4), // Add spacing
                    // Limit the number of lines for the subscription text
                    // Text(
                    //   product.subscription,
                    //   maxLines: 2, // Adjust as needed
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
