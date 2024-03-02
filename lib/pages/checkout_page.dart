import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/main.dart';
import 'package:ingresso_aquii/models/product.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CardFieldInputDetails? _card;
  bool loading = false;

  String getValueTotal() {
    return Provider.of<Shop>(context, listen: false).formatTotalPrice();
  }

  List getShoppingCart() {
    return Provider.of<Shop>(context, listen: false).cart;
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
              CardFormField(
                enablePostalCode: false,
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

  processPayment() async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    final cart = getShoppingCart();
    print(cart);
    // final response = await paymentClient.processPayment(
    //   paymentMethodId: paymentMethod.id,
    //   items: cart,
    // );

    // print(response);
  }
}
