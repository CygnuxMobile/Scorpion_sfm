// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import "package:http/http.dart" as http;
//
//
// class AppNotificationHandler {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     importance: Importance.high,
//   );
//   // final homeController = Get.put(HomeController());
//   // final chatController = Get.put(ChatController());
//
//   static Future<void> firebaseNotificationSetup() async {
//     debugPrint("in this call");
//     await Firebase.initializeApp();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       RemoteNotification? notification = message.notification;
//       debugPrint(
//           'Notification Call :${notification?.apple}${notification!.body}${notification.title}');
//       var android = const AndroidNotificationDetails(
//         'channel DESCRIPTION',
//         'channel DESCRIPTION',
//         color: Colors.black,
//         icon: 'ic_launcher',
//         priority: Priority.high,
//         importance: Importance.max,
//         playSound: true,
//       );
//       var iOS = const DarwinNotificationDetails(
//         presentAlert: true,
//         presentSound: true,
//       );
//       var platform = NotificationDetails(android: android, iOS: iOS);
//       await FlutterLocalNotificationsPlugin().show(message.notification!.hashCode,
//           message.notification!.title, message.notification!.body, platform,
//           payload: message.notification!.title);
//     }).onError((e) {
//       debugPrint('Error Notification : ....$e');
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Notification Screen = ${message.data}");
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     if (message.notification != null) {}
//   }
//
//
//
//
//
//   void showNotification(RemoteMessage message) async {
//     // final data = jsonDecode(message.data['isChatScreen']);
//     // debugPrint("Dataa=======$data");
//     var android = const AndroidNotificationDetails(
//       'channel DESCRIPTION',
//       'channel DESCRIPTION',
//       color: Colors.black,
//       icon: 'ic_launcher',
//       priority: Priority.high,
//       importance: Importance.max,
//       playSound: true,
//     );
//     var iOS = const DarwinNotificationDetails(
//       presentAlert: true,
//       presentSound: true,
//     );
//     var platform = NotificationDetails(android: android, iOS: iOS);
//     await FlutterLocalNotificationsPlugin().show(message.notification!.hashCode,
//         message.notification!.title, message.notification!.body, platform,
//         payload: message.notification!.title);
//   }
//
//   @pragma('vm:entry-point')
//   Future<void> onMessageOpenedApp(RemoteMessage message) async {
//     debugPrint("notification Tap");
//     debugPrint("${message.data}");
//
//     /* .whenComplete(() {
//       chatController.chatSocket!.emit('chatRoomList', {"x-auth-token": pref!.getString("token")});
//     });*/
//     // await chatController.getUnreadCount(isAdmin: true);
//     // await chatController.getUnreadCount(isAdmin: false);
//   }
//
//   @pragma('vm:entry-point')
//   void onMessageOpenedApp1(payload) async {
//     if (payload == "Mokx") {
//       debugPrint("1onmsg======>>>>>ifffappclose$payload");
//       // Get.to(() => const ChatScreen());
//       // await chatController.deliverMessage(isAdmin: false);
//     } else if (payload == "Mokx Admin") {
//       debugPrint("1onmsg======>>>>>Mokx admin$payload");
//       // Get.to(() => const ChatScreen());
//       // await chatController.deliverMessage(isAdmin: true);
//     } else {
//       debugPrint("1onmsg======>>>>>elseappclose$payload");
//       if (Get.currentRoute != "/NotificationScreen") {
//         // Get.to(() => const NotificationScreen());
//       }
//       // homeController.unreadNotificationCount.value = 0;
//       // homeController.getNotification();
//       // homeController.getTask();
//     }
//     // await chatController.getUnreadCount(isAdmin: true);
//     // await chatController.getUnreadCount(isAdmin: false);
//   }
//
//   Future onBackgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     debugPrint(
//         'Main::FirebaseMessaging.onBackgroundMessage 11111=> ${message.data}');
//     // showNotification(message);
//   }
//
//   Future<void> configureNotifications() async {
//     if (Platform.isAndroid) {
//       FirebaseMessaging.onMessage.listen(
//         (RemoteMessage message) {
//           debugPrint("Git message --> ${message.notification!.android}");
//           RemoteNotification? notification = message.notification;
//           AndroidNotification? android = message.notification?.android;
//           if (notification != null && android != null) {
//             flutterLocalNotificationsPlugin.show(
//               notification.hashCode,
//               notification.title,
//               notification.body,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(channel.id, channel.name,
//                     enableVibration: true,
//                     icon: "ic_launcher",
//                     importance: Importance.high),
//               ),
//             );
//           }
//         },
//       );
//
//       FlutterLocalNotificationsPlugin().initialize(
//         const InitializationSettings(
//
//           android: AndroidInitializationSettings(
//             'ic_launcher',
//           ),
//         ),
//
//         // onDidReceiveBackgroundNotificationResponse: (details) {
//         //   print("oooooooooo======>>>>>$details");
//         //   onMessageOpenedApp1(details.payload);
//         // },
//
//       );
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         debugPrint('Main::FirebaseMessaging.onMessage => ${message.data}');
//         showNotification(message);
//         if (message.notification!.title == "Mokx") {
//           debugPrint("oooooooooo======>>>>>ifffappopen");
//           // await chatController.deliverMessage(isAdmin: false);
//         } else if (message.notification!.title == "Mokx Admin") {
//           debugPrint("oooooooooo======>>>>>ifffappopen");
//           // await chatController.deliverMessage(isAdmin: true);
//         } else {
//           debugPrint("oooooooooo======>>>>>elseappopen");
//           // homeController.getNotification();
//           // homeController.getTask();
//         }
//         // await chatController.getUnreadCount(isAdmin: true);
//         // await chatController.getUnreadCount(isAdmin: false);
//       });
//       FirebaseMessaging.onMessageOpenedApp.listen((event) {
//         debugPrint("oooooooooo======>>>>>$event");
//         onMessageOpenedApp(event);
//       });
//
//       // FirebaseMessaging.instance
//       //     .getInitialMessage()
//       //     .then((RemoteMessage? message) {
//       //   debugPrint("oooooooooo======>>>>>getInitialMessage${message!.data}");
//       //   onMessageOpenedApp(message);
//       // });
//       // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } else {
//       FlutterLocalNotificationsPlugin().initialize(
//         const InitializationSettings(
//           android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//           iOS: DarwinInitializationSettings(
//             defaultPresentAlert: true,
//             defaultPresentBadge: true,
//             defaultPresentSound: true,
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//
//           ),
//         ),
//       );
//       FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//         sound: true,
//         badge: true,
//         alert: true,
//       );
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         debugPrint('Main::FirebaseMessaging.onMessage => ${message.data}');
//         showNotification(message);
//         if (message.notification!.title == "Mokx") {
//           debugPrint("oooooooooo======>>>>>ifffappopen");
//           // await chatController.deliverMessage(isAdmin: false);
//         } else if (message.notification!.title == "Mokx Admin") {
//           debugPrint("oooooooooo======>>>>>ifffappopen");
//           // await chatController.deliverMessage(isAdmin: true);
//         } else {
//           debugPrint("oooooooooo======>>>>>elseappopen");
//           // homeController.getNotification();
//           // homeController.getTask();
//         }
//         // await chatController.getUnreadCount(isAdmin: true);
//         // await chatController.getUnreadCount(isAdmin: false);
//       });
//       FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
//       FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//     }
//   }
//
//   Future<void> sendNotification(
//       {String? fcmToken, String? title, String? body}) async {
//     String serverKey =
//         'AAAA8tXdshA:APA91bE6W1ARwXNhyWC2yaEAEZio2y0jzEJpjR8BaGWnj7mwYADBkMZi57v3Y6KqUspc76AVXBnILfZgfYSdJEU8iHooSSMjoOuY_t9ANJYvBoWd2jLDASB94mvCKhAiPU9eudkB4aW7';
//     String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     };
//     Map<String, dynamic> notification = {
//       'notification': {
//         'title': title,
//         // 'body': chatController.isImageChecker(value: body)
//         //     ? "Image"
//         //     : chatController.isFileChecker(value: body)
//         //         ? "${body!.split(".").last.capitalizeFirst!} File"
//         //         : body!.split(".").last == "pdf"
//         //             ? "Pdf"
//         //             : body,
//       },
//       "data": {
//         "isChatScreen": true,
//       },
//       'to': "$fcmToken",
//     };
//     debugPrint("jkhgkfh$notification");
//     try {
//       var response = await http.post(
//         Uri.parse(fcmUrl),
//         headers: headers,
//         body: jsonEncode(notification),
//       );
//       if (response.statusCode == 200) {
//         debugPrint('Notification sent successfully');
//       } else {
//         debugPrint(
//             'Failed to send notification. Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Exception while sending notification: $e');
//     }
//   }
// }
