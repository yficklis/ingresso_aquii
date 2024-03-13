import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/pages/checkout_page.dart';
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
        print("Failed with error '${e.code}': ${e.message}");
        return '';
      }
    } catch (e) {
      // Log or handle other exceptions
      print("Failed with error catch '${e}'");
      return '';
    }
    return '';
  }

  Future<Map<String, dynamic>> retrieveAllLotesByCinemaId(
      String cinemaId) async {
    try {
      // Reference to the "lotes" subcollection
      CollectionReference lotesRef = FirebaseFirestore.instance
          .collection('cinemas')
          .doc(cinemaId)
          .collection('lotes');

      // Retrieve all "lotes" of the cinema
      QuerySnapshot lotesSnapshot =
          await lotesRef.where('status', isEqualTo: true).get();

      // Convert QuerySnapshot to a Map<String, dynamic>
      Map<String, dynamic> lotesData = {};
      for (QueryDocumentSnapshot doc in lotesSnapshot.docs) {
        lotesData[doc.id] = doc.data();
      }
      return lotesData;
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return {};
    } catch (e) {
      print("Failed with error catch '${e}'");
      return {};
    }
  }

  Future<List> checkIfProductExistInLote(
      String cinemaId, String loteId, String itemCollection) async {
    // Reference to the "item" subcollection inside the current "lote"
    CollectionReference itemRef = FirebaseFirestore.instance
        .collection('cinemas')
        .doc(cinemaId)
        .collection('lotes')
        .doc(loteId)
        .collection(itemCollection);

    // Limit the number of "item"
    Query itemQuery = itemRef
        .where('status', isEqualTo: true)
        .where('vendido', isEqualTo: false);

    // Retrieve all "item" documents inside the current "lote"
    QuerySnapshot itemSnapshot = await itemQuery.get();

    if (!itemSnapshot.docs.isNotEmpty) {
      return [];
    }
    List listProduct = [];
    for (QueryDocumentSnapshot itemDocument in itemSnapshot.docs) {
      listProduct.add(itemDocument.id);
    }
    return listProduct;
  }

  Future<void> finishPurcheseByType(String type, int limit) async {
    String cinemaId =
        await getIdMovieTheatherByName('Praia Grande', 'regional');

    if (cinemaId != '') {
      // Retrieve all "lotes" of the cinema
      Map lotesSnapshot = await this.retrieveAllLotesByCinemaId(cinemaId);
      Map listProductByLote = {};
      if (!lotesSnapshot.isEmpty) {
        // Iterate through each "lote" document
        for (final loteId in lotesSnapshot.keys) {
          List productList =
              await checkIfProductExistInLote(cinemaId, loteId, type);
          if (productList.length > 0) {
            listProductByLote[loteId] = productList;
          }
        }
        if (chekcQuantityByProdcut(listProductByLote, limit, type)) {
          Map dados = {'cinemaId': cinemaId, 'type': type, 'limit': limit};
          Navigator.pop(context);
          payNowStripe(dados);
        }
      }
    }
  }

  bool chekcQuantityByProdcut(Map listProductByLote, int limit, String type) {
    if (!listProductByLote.isNotEmpty) {
      Navigator.pop(context);
      openAnimetedDialog(
        'Desculpe',
        'Quantidade de ${type} selecionados, não estão indisponiveis, por favor tente mais tarde!',
      );

      return false;
    }
    List qtdProduct = [];
    listProductByLote.forEach((key, value) {
      qtdProduct = List.from(qtdProduct)..addAll(value);
    });
    if (qtdProduct.length < limit) {
      Navigator.pop(context);
      openAnimetedDialog(
        'Desculpe',
        'Quantidade de ${type} selecionados, não estão indisponiveis, por favor tente mais tarde!',
      );
      return false;
    }
    return true;
  }

  void payNowStripe(Map data) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(data: data),
        // builder: (context) => MaintenancePage(),
      ),
    );
  }

  // pay button tapped
  void payNow() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // get quantidade de ingressos
      int qtdTicket = Provider.of<Shop>(context, listen: false)
          .getTotalItemForSale('ingressos');

      // get quantidade de combos
      int qtdCombo = Provider.of<Shop>(context, listen: false)
          .getTotalItemForSale('combos');

      if (qtdCombo > 0) {
        await finishPurcheseByType('combos', qtdCombo);
      }

      if (qtdTicket > 0) {
        await finishPurcheseByType('ingressos', qtdTicket);
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      openAnimetedDialog("Failed with error '${e.code}'", '${e.message}');
    } catch (e) {
      Navigator.pop(context);
      openAnimetedDialog("Failed with error '${e}'", '${e}');
    }
  }

  void openAnimetedDialog(String title, String content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(microseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  color: Color(0xff6003A2),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Text(
                content,
                style: const TextStyle(
                  color: Color(0xff6003A2),
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
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
