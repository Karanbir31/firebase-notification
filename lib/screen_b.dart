import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = Get.arguments?? "UserId NA";
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen B"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Center(child: Text("Screen B and userID -- $userId", style: TextStyle(fontSize: 20))),
    );
  }
}
