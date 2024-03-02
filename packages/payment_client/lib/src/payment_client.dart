import 'dart:convert';

import 'package:http/http.dart' as http;

const ENDPOINT_METHOD_ID_URL =
    "https://stripe-pay-endpoint-method-id-sfaan4wm4a-uc.a.run.app";

class PaymentClient {
  final http.Client client;
  PaymentClient({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> processPayment({
    required String paymentMethodId,
    required List<Map<String, dynamic>> items,
    String currency = 'brl',
    bool useStripeSdk = true,
  }) async {
    final url = Uri.parse(ENDPOINT_METHOD_ID_URL);
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'paymentMethodId': paymentMethodId,
        'items': items,
        'currency': currency,
        'useStripeSdk': useStripeSdk,
      }),
    );
    return json.decode(response.body);
  }

  confirmPayment() {
    throw UnimplementedError();
  }
}
