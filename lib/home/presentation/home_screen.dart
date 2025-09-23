import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynotification/home/controller/home_controller.dart';
import 'package:mynotification/payments_screen/payments_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FCM Notification"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            Center(
              child: Obx(() {
                if (controller.isNotificationPermissionGranted.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Notification permission is granted"),
                      const SizedBox(height: 12),
                      Obx(
                        () =>
                            Text("FCM Token: ${controller.userFcmToken.value}"),
                      ),
                    ],
                  );
                } else {
                  return ElevatedButton(
                    onPressed: controller.requestNotificationPermission,
                    child: const Text("Enable Notification Permission"),
                  );
                }
              }),
            ),

            ElevatedButton(
              onPressed: () {
                Get.to(PaymentTestScreen());
              },
              child: const Text("Navigate to payments screen"),
            ),
          ],
        ),
      ),
    );
  }
}
