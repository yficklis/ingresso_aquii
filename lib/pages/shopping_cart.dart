import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/pages/checkout_page.dart';
import 'package:ingresso_aquii/pages/maintenance_page.dart';
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

  String? cinemaId;

  void removeFromCart(Product product) {
    Provider.of<Shop>(context, listen: false).removeFromCart(product);
  }

  String getValueTotal() {
    return Provider.of<Shop>(context, listen: false).formatTotalPrice();
  }

  Future<String?> getIdMovieTheatherByName(String cineName, String type) async {
    try {
      final cinemasSnapshot = await FirebaseFirestore.instance
          .collection('cinemas')
          .where('unidade', isEqualTo: cineName)
          .where('tipo', isEqualTo: type)
          .where('status', isEqualTo: true)
          .limit(1)
          .get();

      return cinemasSnapshot.docs.isNotEmpty
          ? cinemasSnapshot.docs.first.id
          : null;
    } on FirebaseAuthException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return null;
    } catch (e) {
      print("Failed with error catch '${e}'");
      return null;
    }
  }

  Future<Map<String, dynamic>> retrieveAllLotesByCinemaId(
      String cinemaId) async {
    try {
      final lotesSnapshot = await FirebaseFirestore.instance
          .collection('cinemas')
          .doc(cinemaId)
          .collection('lotes')
          .where('status', isEqualTo: true)
          .get();

      return {
        for (final doc in lotesSnapshot.docs) doc.id: doc.data(),
      };
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return {};
    } catch (e) {
      print("Failed with error catch '${e}'");
      return {};
    }
  }

  Future<List<String>> checkIfProductExistInLote(
      String cinemaId, String loteId, String itemCollection) async {
    final itemSnapshot = await FirebaseFirestore.instance
        .collection('cinemas')
        .doc(cinemaId)
        .collection('lotes')
        .doc(loteId)
        .collection(itemCollection)
        .where('status', isEqualTo: true)
        .where('vendido', isEqualTo: false)
        .get();

    return itemSnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> finishPurcheseByType(String type, int limit) async {
    cinemaId = await getIdMovieTheatherByName('Praia Grande', 'regional');

    if (cinemaId != null) {
      final lotesSnapshot = await retrieveAllLotesByCinemaId(cinemaId!);
      final listProductByLote = <String, List<String>>{};

      for (final loteId in lotesSnapshot.keys) {
        final productList =
            await checkIfProductExistInLote(cinemaId!, loteId, type);
        if (productList.isNotEmpty) {
          listProductByLote[loteId] = productList;
        }
      }

      if (checkQuantityByProduct(listProductByLote, limit)) {
        final data = {'cinemaId': cinemaId, 'type': type, 'limit': limit};
        Navigator.pop(context);
        payNowStripe(data);
      }
    }
  }

  bool checkQuantityByProduct(
      Map<String, List<String>> listProductByLote, int limit) {
    if (listProductByLote.isEmpty) {
      Navigator.pop(context);
      openAnimatedDialog(
        'Desculpe',
        'A quantidade selecionada não está disponível. Por favor, tente novamente mais tarde!',
      );
      return false;
    }

    final qtdProduct =
        listProductByLote.values.expand((products) => products).toList();

    if (qtdProduct.length < limit) {
      Navigator.pop(context);
      openAnimatedDialog(
        'Desculpe',
        'A quantidade selecionada não está disponível. Por favor, tente novamente mais tarde!',
      );
      return false;
    }
    return true;
  }

  void payNowStripe(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => CheckoutPage(data: data),
        builder: (context) => MaintenancePage(),
      ),
    );
  }

  void openAnimatedDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: const Color(0xff6003A2),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: const Color(0xff6003A2),
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
        );
      },
    );
  }

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
      final qtdTicket = Provider.of<Shop>(context, listen: false)
          .getTotalItemForSale('ingressos');
      final qtdCombo = Provider.of<Shop>(context, listen: false)
          .getTotalItemForSale('combos');

      if (qtdCombo > 0) {
        await finishPurcheseByType('combos', qtdCombo);
      }

      if (qtdTicket > 0) {
        await finishPurcheseByType('ingressos', qtdTicket);
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      openAnimatedDialog("Falha com o erro '${e.code}'", '${e.message}');
    } catch (e) {
      Navigator.pop(context);
      openAnimatedDialog("Falha com o erro '${e}'", '${e}');
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
