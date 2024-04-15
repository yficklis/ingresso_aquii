import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/default_button.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantityCount = 0;
  // decrement
  void decrementQuantity() {
    if (quantityCount > 0) {
      setState(() {
        quantityCount--;
      });
    }
  }

  //
  void incrementQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  void addTocard() {
    // Only add to cart if there is something in the cart
    if (quantityCount > 0) {
      // get access to shop
      final shop = context.read<Shop>();

      // add to cart
      shop.addToCart(widget.product, quantityCount);

      // let the user know it was successful
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) => AlertDialog(
          content: Text(
            'Adicionado com sucesso ao carrinho!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: IconButton(
                onPressed: () {
                  // pop once to remove dialog box
                  Navigator.pop(context);
                  // pop again to go previus screen
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.done,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Column(
        children: [
          // listview of product details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ListView(
                children: [
                  // image
                  Image.asset(
                    widget.product.imagePath,
                    height: 200,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    widget.product.subscription,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Descrição",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresso válido apenas para a sessão e a data indicadas. Não é permitida a entrada após o início do filme. O ingresso é pessoal e intransferível. Não nos responsabilizamos por ingressos perdidos ou roubados. Por favor, mantenha o ingresso em mãos para apresentação na entrada da sala.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'Roboto',
                    ),
                  )
                ],
              ),
            ),
          ),
          // price + quantity + add to cart button

          Container(
            color: Color(0xff6003A2),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // price + quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${widget.product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    // quantity
                    Row(
                      children: [
                        // minus button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.black,
                            ),
                            onPressed: decrementQuantity,
                          ),
                        ),
                        //quantity count
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              quantityCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        //plus button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: incrementQuantity,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // add to cart button
                DefaultButton(
                  onPressed: addTocard,
                  borderRadius: BorderRadius.circular(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // text
                      Text(
                        'Adicionar ao carrinho',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
