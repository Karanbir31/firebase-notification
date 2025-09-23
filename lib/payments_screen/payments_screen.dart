import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentTestScreen extends StatefulWidget {
  const PaymentTestScreen({super.key});

  @override
  PaymentTestScreenState createState() => PaymentTestScreenState();
}

class PaymentTestScreenState extends State<PaymentTestScreen> {
  final Dio dio = Dio();
  Map<String, dynamic>? paymentIntentData;

  final String pkTestKey =
      "pk_test_51SARjSHmLrW0ud9mw1ssIhLU2po5MHZFqBfl0dfZtswcF5GcFpzm3ItUTL2OU2XdJxrisg7MDKChPKN4LZBOmUHb00D76V9mrC";

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = pkTestKey;
  }

  Future<void> makePayment(String amount) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user is logged in");

      final idToken = await user.getIdToken();

      // 1️⃣ Create PaymentIntent via your Cloud Function
      final response = await dio.post(
        'https://createpaymentintent-rk4g6u5kpq-uc.a.run.app/create-payment-intent',
        data: {'amount': int.parse(amount), 'currency': 'usd'},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      paymentIntentData = response.data;
      final clientSecret = paymentIntentData!['clientSecret'];

      // 2️⃣ Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Flutter Stripe Demo',
          customFlow: false,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            testEnv: true,
          ),
          style: ThemeMode.system,
        ),
      );

      // 3️⃣ Present Payment Sheet
      await displayPaymentSheet();
    } catch (e) {
      debugPrint("❌ PaymentScreen: makePayment error -> $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint("✅ PaymentScreen: Payment successful");
      paymentIntentData = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful')),
      );
    } on StripeException catch (e) {
      debugPrint("❌ PaymentScreen: Stripe exception -> $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      debugPrint("❌ PaymentScreen: Unknown error -> $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => makePayment("1000"), // Amount in cents ($50)
          child: const Text('Pay \$10'),
        ),
      ),
    );
  }
}
