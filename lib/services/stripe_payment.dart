import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/User%20Home%20Screen/Resturants/order_success.dart';

class PaymentController  {
  Map<String, dynamic>? paymentIntentData;
  String payIntentId1 = 'o';
  Future<void> makePayment(String amount,BuildContext context) async {
    try {
      Map<String, dynamic>? paymentIntent;
      paymentIntent = await createPaymentIntent(amount, 'GBP');
      payIntentId1 = savePayIntent(paymentIntent);
      // Utils().toastMessage(' pay Int Id====$payIntentId1');
      var gPay = const PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      // STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], // Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'laundry',
              googlePay: gPay,
            ),
          )
          .then((value) {});

      // STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      Utils().toastMessage(err.toString());
    }
  }

  // Function to initiate a refund for a payment
  String savePayIntent(Map? intent) {
    if (intent != null) {
      payIntentId1 = (intent['id'] as String?)!;
      // Utils().toastMessage(intent.toString());
    }
    return payIntentId1;
  }

  Future<void> refundStripePayment(String paymentIntentId) async {
    // Replace 'your_stripe_secret_key' with your actual Stripe secret key
    const apiKey =
        'sk_test_51PD3Ed01S11KKkLeD9HyBibf0eziIrqwlSp2K0H5VmDezoiZUvqx8vxTfW88uBC3qq0k6EsaaW6MsAkc6ZeffBkL00qPe0CP1y';

    const url = 'https://api.stripe.com/v1/refunds';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'payment_intent': paymentIntentId,
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // Refund successful
      Utils().toastMessage('Refund successful');
    } else {
      // Refund failed, handle the error
      Utils().toastMessage('Refund not successful');
      if (kDebugMode) {
        print('Refund failed: ${response.statusCode}, ${response.body}');
      }
      // You may want to throw an exception or handle the error in a different way
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()));
        Utils().toastMessage('Payment Successful');
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
      if (kDebugMode) {
        print("errorrrrrrr::$e");
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51PD3Ed01S11KKkLeD9HyBibf0eziIrqwlSp2K0H5VmDezoiZUvqx8vxTfW88uBC3qq0k6EsaaW6MsAkc6ZeffBkL00qPe0CP1y',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      Utils().toastMessage(err.toString());
    }
  }
}

