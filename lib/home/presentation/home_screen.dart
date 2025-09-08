import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynotification/home/controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FCM Notification"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: Center(
          child: Obx(
            () => Text("User fcm token is -- ${controller.userFcmToken}"),
          ),
        ),
      ),
    );
  }
}
