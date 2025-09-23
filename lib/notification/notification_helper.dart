import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mynotification/screen_a.dart';
import 'package:mynotification/screen_b.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationHelper.instance.showNotification(message);
}

class NotificationHelper {
  // Channel config
  static const String androidChannelId = "my_channel_id";
  static const String androidChannelName = "My Notifications";
  static const String androidChannelDescription =
      "This channel is used for important notifications.";

  NotificationHelper._privateConstructor();

  static final NotificationHelper instance =
      NotificationHelper._privateConstructor();

  final _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  String? token;

  /// Call this once during app initialization
  Future<void> init() async {
    //  Get FCM token
    token = await _fcm.getToken();
    debugPrint("NotificationHelper FCM Token: $token");

    //  Init notification settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotification.initialize(
      settings,
      //onDidReceiveBackgroundNotificationResponse: handleNotificationResponse,
      onDidReceiveNotificationResponse: handleNotificationResponse,
    );

    //  Create Android channel explicitly
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      androidChannelId,
      androidChannelName,
      description: androidChannelDescription,
      importance: Importance.high,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    //  Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    //  Listen for background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification(RemoteMessage message) async {
    bool isNotifyPermissionGranted = await checkNotificationPermission();
    if (!isNotifyPermissionGranted) {
      debugPrint(
        " \n\n<<=======================Need Notification permission ------>> \n\n",
      );
      return;
    }

    final notification = message.notification;
    final androidNotification = message.notification?.android;
    String? playLoadFromFCM = message.data.isNotEmpty
        ? jsonEncode(message.data)
        : null;

    if (notification != null && androidNotification != null) {
      String? imageUrl =
          notification.android?.imageUrl ?? notification.apple?.imageUrl;

      BigPictureStyleInformation? bigPictureStyleInformation;
      AndroidBitmap<Object>? largeIconBitmap;

      //  Try downloading image if available
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final httpImage = await _downloadAndSaveFile(
            imageUrl,
            'bigPicture.jpg',
          );
          final bigPicture = FilePathAndroidBitmap(httpImage);
          largeIconBitmap = FilePathAndroidBitmap(httpImage);
          bigPictureStyleInformation = BigPictureStyleInformation(
            bigPicture,
            contentTitle: notification.title,
            summaryText: notification.body,
          );
        } catch (e) {
          debugPrint(" Failed to load image: $e");
        }
      }

      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            androidChannelId,
            androidChannelName,
            channelDescription: androidChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            onlyAlertOnce: true,
            styleInformation: bigPictureStyleInformation,
            largeIcon: largeIconBitmap,
            icon: '@drawable/ic_logo',

            setAsGroupSummary: true,
            groupKey: "group_key",

            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                "action_cancel",
                "Close",
                showsUserInterface: true,
                cancelNotification: true,
              ),
              AndroidNotificationAction(
                "action_open",
                "Open",
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ],
          );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _localNotification.show(
        notification.hashCode,
        notification.title,
        "${notification.body} --> play load is -- $playLoadFromFCM",
        notificationDetails,
        payload: playLoadFromFCM,
      );
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    debugPrint("NotificationHelper Image from url is saved at $filePath");
    return filePath;
  }

  void handleNotificationResponse(NotificationResponse response) {
    if (response.actionId == "action_cancel") {
      _localNotification.cancel(response.id ?? 0);

      Get.snackbar(
        "button click",
        "You click cancel button in notification",
        backgroundColor: Colors.blueAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (response.payload != null) {
      // play load contain two keys and values 1st screenId and userId
      try {
        final data = jsonDecode(response.payload!);
        final screenId = data['screenId'] ?? "A";
        final userID = data['userId'] ?? "userID NA";
        if (screenId == 'A' || screenId == 'a') {
          Get.to(ScreenA(), arguments: userID);
        } else {
          Get.to(ScreenB(), arguments: userID);
        }
        debugPrint(
          "NotificationHelper Notification tapped, payload screenId -- $screenId and userId -- $userID",
        );
      } catch (error) {
        debugPrint(
          "NotificationHelper error in onDidReceiveNotificationResponse $error ",
        );
      }
    }
  }

  Future<bool> checkNotificationPermission() async {
    final notifyPermission = Permission.notification;
    bool isGranted = await notifyPermission.isGranted;
    return isGranted;
  }
}
