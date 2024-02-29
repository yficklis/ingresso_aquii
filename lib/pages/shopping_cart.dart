import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/util/empty_shopping_cart.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/components/product_tile_cart.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final user = FirebaseAuth.instance.currentUser!;
  void removeFromCart(Product product) {
    Provider.of<Shop>(context, listen: false).removeFromCart(product);
  }

  String getValueTotal() {
    return Provider.of<Shop>(context, listen: false).formatTotalPrice();
  }

  Future<String> getIdMovieTheatherByName(String cineName, String type) async {
    try {
      CollectionReference cinemaRef =
          FirebaseFirestore.instance.collection('cinemas');
      QuerySnapshot cinemasSnapshot = await cinemaRef
          .where('unidade', isEqualTo: cineName)
          .where('tipo', isEqualTo: type)
          .where('status', isEqualTo: true)
          .get();

      return (cinemasSnapshot.docs.isNotEmpty)
          ? cinemasSnapshot.docs.first.id
          : '';
    } on FirebaseAuthException catch (e) {
      if (e.code != '') {
        // Log or handle the FirebaseAuthException
        print('FirebaseAuthException: ${e.code}');
        return '';
      }
    } catch (e) {
      // Log or handle other exceptions
      print('Error: $e');
      return '';
    }
    return '';
  }

  Future<QuerySnapshot> retrieveAllLotesByCinemaId(String cinemaId) async {
    // Reference to the "lotes" subcollection
    CollectionReference lotesRef = FirebaseFirestore.instance
        .collection('cinemas')
        .doc(cinemaId)
        .collection('lotes');

    // Retrieve all "lotes" of the cinema
    QuerySnapshot lotesSnapshot =
        await lotesRef.where('status', isEqualTo: true).get();
    return lotesSnapshot;
  }

  retriveSubCollectionByLote(
    String cinemaId,
    String loteId,
    String itemCollection,
    int limit,
  ) async {
    // Reference to the "item" subcollection inside the current "lote"
    CollectionReference itemRef = FirebaseFirestore.instance
        .collection('cinemas')
        .doc(cinemaId)
        .collection('lotes')
        .doc(loteId)
        .collection(itemCollection);

    // Limit the number of "ingresso" documents to 5
    Query itemQuery = itemRef
        .where('status', isEqualTo: true)
        .where('vendido', isEqualTo: false)
        .limit(limit);

    // Retrieve all "item" documents inside the current "lote"
    QuerySnapshot itemSnapshot = await itemQuery.get();

    // Process each "item" document
    for (QueryDocumentSnapshot itemDocument in itemSnapshot.docs) {
      // Access the "item" document ID
      String itemId = itemDocument.id;

      // Update the "vendido" attribute to false
      await itemRef.doc(itemId).update({'vendido': true});

      // Create a subcollection inside the "user" collection to store the "item" IDs
      CollectionReference userTicketsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('my_tickets');

      // Add the "item" ID to the "my_tickets" subcollection inside
      await userTicketsRef.add({
        'itemId': itemId,
        'type': itemCollection,
        'status': true,
      });
    }
  }

  // pay button tapped
  void payNow() async {
    String cinemaId =
        await getIdMovieTheatherByName('Praia Grande', 'regional');

    // Retrieve all "lotes" of the cinema
    QuerySnapshot lotesSnapshot =
        await this.retrieveAllLotesByCinemaId(cinemaId);

    // Iterate through each "lote" document
    for (QueryDocumentSnapshot loteDocument in lotesSnapshot.docs) {
      // Access the "lote" document ID
      String loteId = loteDocument.id;
      retriveSubCollectionByLote(cinemaId, loteId, 'combos', 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (value.cart.length == 0) EmptyShoppingCart(),
              if (value.cart.length > 0)
                Text(
                  "Seu carrinho",
                  style: GoogleFonts.dmSerifDisplay(fontSize: 28),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.cart.length,
                  itemBuilder: (context, index) {
                    // get individual ticket
                    Product eachProduct = value.cart[index];

                    // return movie ticket tile
                    return ProductTileCart(
                      product: eachProduct,
                      onPressed: () => removeFromCart(eachProduct),
                      icon: Icon(Icons.delete),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              if (value.cart.length > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // message
                    Text(
                      'Valor total:',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28,
                        color: Color(0xff363435),
                      ),
                    ),
                    Text(
                      '${getValueTotal()}',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28,
                        color: Color(0xff363435),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 25),
              // pay button
              if (value.cart.length > 0)
                GradientButton(
                  onPressed: () {
                    payNow();
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // text
                      Text(
                        'Prosseguir para pagamento',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
