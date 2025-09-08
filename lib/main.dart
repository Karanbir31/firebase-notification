import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynotification/home/controller/home_binding.dart';
import 'package:mynotification/home/controller/home_controller.dart';
import 'package:mynotification/home/presentation/home_screen.dart';
import 'package:mynotification/notification/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

      onInit: (){
        Get.lazyPut(()=>HomeController());
      },

      home: HomeScreen(),
      getPages: [
        GetPage(
          name: "/home",
          page: () =>  HomeScreen(),
          binding: HomeBinding()
        ),
      ],
    );
  }
}
