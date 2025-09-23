import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = Get.arguments ?? "UserId NA";

    return Scaffold(
      appBar: AppBar(
        title: Text("Screen A"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Text(
          "Screen A and userId -- $userId",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
