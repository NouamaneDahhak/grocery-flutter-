import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:grocery/helpers/project_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  static init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: ProjectConfiguration.stripePublishableKey,
      merchantId: ProjectConfiguration.stripeMerchantId,
    ));
  }

  static Future<String> payWithCard(String amount) async {
    init();

    var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest());
    var paymentIntent = await StripeService.createPaymentIntent(
      amount,
    );
    var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id));

    if (response.status == 'succeeded') {
      print('Transaction successful');

      return response.toJson()["paymentIntentId"];
    } else {
      throw PlatformException(code: "0", message: "Transaction failed");
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
    var response = await http.post(
      Uri.parse(ProjectConfiguration.stripePaymentApi),
      body: {
        'amount': amount,
        'currency': 'usd',
        'payment_method_types[]': 'card'
      },
    );

    print(response.body);
    return jsonDecode(response.body);
  }
}
