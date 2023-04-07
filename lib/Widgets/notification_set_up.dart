// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // ignore: depend_on_referenced_packages
// import 'package:timezone/timezone.dart' as tz;
// // ignore: depend_on_referenced_packages
// import 'package:timezone/data/latest.dart' as tz;
//
// class NotificationService {
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initializeNotification() async {
//      AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//      IOSInitializationSettings initializationSettingsIOS = const IOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );
//      InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(int id, String title, String body) async {
//     var dateTime = DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day, 22, 19, 0);
//     tz.initializeTimeZones();
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(dateTime, tz.local),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//             id.toString(),
//             'Go To Bed',
//             importance: Importance.max,
//             priority: Priority.max,
//             icon: '@mipmap/ic_launcher'
//         ),
//         iOS:const  IOSNotificationDetails(
//           sound: 'default.wav',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//
//   }
//
// }