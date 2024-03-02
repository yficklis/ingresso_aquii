import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/main.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final Map data;
  const CheckoutPage({
    super.key,
    required this.data,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CardFieldInputDetails? _card;
  bool loading = false;

  String getValueTotal() {
    return Provider.of<Shop>(context, listen: false).formatTotalPrice();
  }

  List<Map<String, dynamic>> getShoppingCart() {
    List<Product> cart = Provider.of<Shop>(context, listen: false).cart;
    List<Map<String, dynamic>> cartList =
        cart.map((product) => product.toJson()).toList();
    return cartList;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finalizar Pagamento',
          style: TextStyle(
            color: Color(0xff6003A2),
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xff6003A2)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Insira os dados do seu cartão',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              // CardFormField(
              //   enablePostalCode: false,
              //   countryCode: 'BR',
              //   onCardChanged: (card) {
              //     setState(() {
              //       _card = card;
              //     });
              //   },
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total:  ${getValueTotal()}',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Color(0xff363435),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: FilledButton(
                onPressed: loading ? null : () => handlePayment(),
                child: const Text(
                  'Pagar agora',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handlePayment() async {
    if (_card?.complete != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete os dados do seu cartão'),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await processPayment();
    } catch (err) {
      throw Exception(err.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> processPayment() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    final cart = getShoppingCart();

    final response = await paymentClient.processPayment(
      paymentMethodId: paymentMethod.id,
      items: cart,
    );

    if (response['status'] == 'succeeded') {
      for (var i = 0; i < widget.data['limit']; i++) {
        await buyItem(widget.data['cinemaId'], widget.data['type']);
      }
      successPurchase();
      return;
    }

    // if (response['requiresAction'] == true &&
    //     response['clientSecret'] != null) {
    //   await Stripe.instance.handleNextAction(response['clientSecret']);
    // }
    print(response);
  }

  Future<void> buyItem(String cinemaId, String item) async {
    // Referência para a subcoleção 'lotes' com filtro para status
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Referência para a coleção 'lotes' do cinema
    QuerySnapshot lotesQuery = await firestore
        .collection('cinemas')
        .doc(cinemaId)
        .collection('lotes')
        .where('status', isEqualTo: true)
        .get();

    for (QueryDocumentSnapshot loteDoc in lotesQuery.docs) {
      // Referência para a subcoleção 'ingressos' do lote
      QuerySnapshot ingressosQuery = await firestore
          .collection('cinemas')
          .doc(cinemaId)
          .collection('lotes')
          .doc(loteDoc.id)
          .collection(item)
          .where('status', isEqualTo: true)
          .where('vendido', isEqualTo: false)
          .get();

      if (ingressosQuery.docs.isNotEmpty) {
        // Obtenha o primeiro ingresso encontrado
        DocumentSnapshot ingressoDoc = ingressosQuery.docs.first;
        // Atualize o ingresso
        await ingressoDoc.reference.update({'vendido': true});
        // Adicione o ingresso à subcoleção 'my_tickets' do usuário
        await addUserTicket(ingressoDoc.id, loteDoc.id, item);
        return;
      }
    }
  }

  Future<void> addUserTicket(String itemId, String loteId, String item) async {
    // Referência para a subcoleção 'my_tickets' do usuário
    final user = FirebaseAuth.instance.currentUser!;
    CollectionReference userTicketsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('my_tickets');

    // Adicione o ingresso à subcoleção 'my_tickets'
    await userTicketsRef.add({
      'loteId': loteId,
      'tipo': item,
      'ingressoId': itemId,
      'status': true,
    });
  }

  void successPurchase() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (builder) => AlertDialog(
        content: const Text(
          'Compra bem sucedida!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                //delete all from cart
                Provider.of<Shop>(context, listen: false).deleteAllFromCart();
                // pop again to go previus screen
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/mytickets',
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(
                Icons.done,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
