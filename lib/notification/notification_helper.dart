import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 // await NotificationHelper.instance.init();
  await NotificationHelper.instance.showNotification(message);
}

class NotificationHelper {
  NotificationHelper._privateConstructor();

  static final NotificationHelper instance =
      NotificationHelper._privateConstructor();

  String? token;

  final _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  /// Call this once during app initialization
  Future<void> init() async {
    // Get FCM token
    token = await _fcm.getToken();

    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotification.initialize(settings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final androidNotification = message.notification?.android;
    //final iosNotification  = message.notification?.apple; similar with android notification
    // contain ios specific notification data

    if (notification != null && androidNotification != null) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            "channelId",
            "channelName",
            channelDescription: "channelDescription",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: "play load",
      );
    }
  }
}
