import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mynotification/auth/authentication_controller.dart';
import 'package:mynotification/auth/authentication_screen.dart';
import 'package:mynotification/home/controller/home_binding.dart';
import 'package:mynotification/home/controller/home_controller.dart';
import 'package:mynotification/home/presentation/home_screen.dart';
import 'package:mynotification/notification/notification_helper.dart';
import 'package:mynotification/payments_screen/payments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe with your publishable key (test mode)
  const String pkTestKey =
      "pk_test_51SARjSHmLrW0ud9mw1ssIhLU2po5MHZFqBfl0dfZtswcF5GcFpzm3ItUTL2OU2XdJxrisg7MDKChPKN4LZBOmUHb00D76V9mrC";

  Stripe.publishableKey = pkTestKey;
  await Stripe.instance.applySettings();

  await Firebase.initializeApp();

  await NotificationHelper.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // initialRoute: "/home",
      onInit: () {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => AuthenticationController());
      },

      home: PaymentTestScreen(),
      getPages: [
        GetPage(
          name: "/home",
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
