// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android);
//     await _plugin.initialize(settings);
//   }

//   static Future<void> showNotification(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'downloads_channel', 'Downloads',
//       channelDescription: 'Notifications for file downloads',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const details = NotificationDetails(android: androidDetails);
//     await _plugin.show(0, title, body, details);
//   }
// }

