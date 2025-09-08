import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mynotification/notification/notification_helper.dart';

class HomeController extends GetxController {
  RxString userFcmToken = "".obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    userFcmToken.value = NotificationHelper.instance.token ?? "NA";

    debugPrint("UserFcmToken is -- $userFcmToken");
  }
}
