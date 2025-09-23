import 'package:get/get.dart';
import 'package:mynotification/notification/notification_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  RxString userFcmToken = "no need to display token ".obs;
  RxBool isNotificationPermissionGranted = false.obs;

  final Permission _notificationPermission = Permission.notification;

  @override
  Future<void> onReady() async {
    await _checkNotificationPermission();
    super.onReady();

    // Listen for FCM token updates
  }

  Future<void> _checkNotificationPermission() async {
    final status = await _notificationPermission.status;
    isNotificationPermissionGranted.value = status.isGranted;
    if(!isNotificationPermissionGranted.value){
      requestNotificationPermission();
    }
  }

  Future<void> requestNotificationPermission() async {
    if (await _notificationPermission.isPermanentlyDenied) {
      openAppSettings();
    } else {
      final response = await _notificationPermission.request();
      isNotificationPermissionGranted.value = response.isGranted;
    }
  }


}
