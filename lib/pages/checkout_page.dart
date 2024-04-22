import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
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
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // String cardNumber = '';
  // String expiryDate = '';
  // String cardHolderName = '';
  // String cvvCode = '';
  // bool isCvvFocused = false;

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
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Finalizar Pagamento',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
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
              // const SizedBox(height: 16.0),
              // CreditCardWidget(
              //   cardNumber: cardNumber,
              //   expiryDate: expiryDate,
              //   cardHolderName: cardHolderName,
              //   cvvCode: cvvCode,
              //   showBackView: isCvvFocused,
              //   onCreditCardWidgetChange: (data) {},
              //   cardBgColor: Theme.of(context).colorScheme.primary,
              //   chipColor: Colors.yellow.shade400,
              //   isHolderNameVisible: true,
              // ),
              // const SizedBox(height: 16.0),
              // CreditCardForm(
              //   cardNumber: cardNumber,
              //   expiryDate: expiryDate,
              //   cardHolderName: cardHolderName,
              //   cvvCode: cvvCode,
              //   inputConfiguration: InputConfiguration(
              //     cardNumberDecoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //           // width: 2,
              //         ),
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //       ),
              //       fillColor: Theme.of(context).colorScheme.onSecondary,
              //       floatingLabelBehavior: FloatingLabelBehavior.always,
              //       hintStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.onSecondary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //       ),
              //       labelStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.primary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //         fontSize: 20.0,
              //       ),
              //       hintText: 'XXXX XXXX XXXX XXXX',
              //       labelText: 'Número do cartão',
              //     ),
              //     expiryDateDecoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //           // width: 2,
              //         ),
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //       ),
              //       fillColor: Theme.of(context).colorScheme.onSecondary,
              //       floatingLabelBehavior: FloatingLabelBehavior.always,
              //       hintStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.onSecondary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //       ),
              //       labelStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.primary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //         fontSize: 20.0,
              //       ),
              //       labelText: 'Data de validade',
              //       hintText: 'XX/XX',
              //     ),
              //     cvvCodeDecoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //           // width: 2,
              //         ),
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //         ),
              //       ),
              //       fillColor: Theme.of(context).colorScheme.onSecondary,
              //       floatingLabelBehavior: FloatingLabelBehavior.always,
              //       hintStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.onSecondary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //       ),
              //       labelStyle: TextStyle(
              //         color: Theme.of(context).colorScheme.primary,
              //         fontFamily: 'Roboto',
              //         fontWeight: FontWeight.w400,
              //         fontSize: 20.0,
              //       ),
              //       labelText: 'CVV',
              //       hintText: 'XXX',
              //     ),
              //     cardHolderDecoration: InputDecoration(
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Theme.of(context).colorScheme.onSecondary,
              //           ),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Theme.of(context).colorScheme.onSecondary,
              //             // width: 2,
              //           ),
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Theme.of(context).colorScheme.onSecondary,
              //           ),
              //         ),
              //         fillColor: Theme.of(context).colorScheme.onSecondary,
              //         floatingLabelBehavior: FloatingLabelBehavior.always,
              //         hintStyle: TextStyle(
              //           color: Theme.of(context).colorScheme.onSecondary,
              //           fontFamily: 'Roboto',
              //           fontWeight: FontWeight.w400,
              //         ),
              //         labelStyle: TextStyle(
              //           color: Theme.of(context).colorScheme.primary,
              //           fontFamily: 'Roboto',
              //           fontWeight: FontWeight.w400,
              //           fontSize: 20.0,
              //         ),
              //         labelText: 'Titular do cartão',
              //         hintText: "Nome do titular"),
              //     cardNumberTextStyle: TextStyle(
              //       fontSize: 16.0,
              //       fontFamily: 'Roboto',
              //       fontWeight: FontWeight.w400,
              //       color: Theme.of(context).colorScheme.secondary,
              //     ),
              //     cardHolderTextStyle: TextStyle(
              //       fontSize: 16.0,
              //       fontFamily: 'Roboto',
              //       fontWeight: FontWeight.w400,
              //       color: Theme.of(context).colorScheme.secondary,
              //     ),
              //     expiryDateTextStyle: TextStyle(
              //       fontSize: 16.0,
              //       fontFamily: 'Roboto',
              //       fontWeight: FontWeight.w400,
              //       color: Theme.of(context).colorScheme.secondary,
              //     ),
              //     cvvCodeTextStyle: TextStyle(
              //       fontSize: 16.0,
              //       fontFamily: 'Roboto',
              //       fontWeight: FontWeight.w400,
              //       color: Theme.of(context).colorScheme.secondary,
              //     ),
              //   ),
              //   onCreditCardModelChange: (data) {
              //     setState(() {
              //       cardNumber = data.cardNumber;
              //       expiryDate = data.expiryDate;
              //       cardHolderName = data.cardHolderName;
              //       cvvCode = data.cvvCode;

              //       String numeroCartao =
              //           data.cardNumber.replaceAll(RegExp(r"\s+"), "");
              //       RegExp regex = RegExp(r'^(\d{2})/(\d{2})$');
              //       RegExpMatch? match = regex.firstMatch(data.expiryDate);

              //       int monthDate = (match != null && match.group(1) != null)
              //           ? int.parse(match.group(1)!)
              //           : 0;

              //       int yearDate = (match != null && match.group(2) != null)
              //           ? int.parse(match.group(2)!)
              //           : 0;

              //       _card = CardFieldInputDetails(
              //         complete: true,
              //         cvc: data.cvvCode,
              //         expiryMonth: monthDate,
              //         expiryYear: yearDate,
              //         number: numeroCartao,
              //       );

              //       CardDetails(
              //         number: numeroCartao,
              //         cvc: data.cvvCode,
              //         expirationMonth: monthDate,
              //         expirationYear: yearDate,
              //       );
              //     });
              //   },
              //   formKey: formKey,
              // ),
              const SizedBox(height: 16.0),
              CardFormField(
                enablePostalCode: false,
                style: CardFormStyle(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onBackground,
                  placeholderColor: Theme.of(context).colorScheme.onBackground,
                  borderColor: Theme.of(context).colorScheme.onBackground,
                  textErrorColor: Colors.red.shade300,
                  borderRadius: 10,
                  fontSize: 16,

                  // borderWidth: 1,
                ),
                countryCode: 'BR',
                onCardChanged: (card) {
                  setState(() {
                    _card = card;
                  });
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total:  ${getValueTotal()}',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                onPressed: loading ? null : () => handlePayment(),
                child: Text(
                  'Pagar agora',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
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
      barrierDismissible: false,
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
        content: Text(
          'Compra bem sucedida!',
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
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
