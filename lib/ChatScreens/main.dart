// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'AuthScreen.dart';
//
// Future<void> backgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("🔔 Background Message: ${message.notification?.title} - ${message.notification?.body}");
// }
//
// final GlobalKey<NavigatorState> navigatorKey =
// GlobalKey<NavigatorState>(debugLabel: "navigator");
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void setupNotificationChannels() {
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'messages_channel',
//     'Chat Messages',
//     description: 'This channel is used for chat messages notifications.',
//     importance: Importance.max,
//   );
//
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("🔔 Terminated Message: ${message.notification?.title}");
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   if (Platform.isAndroid) {
//     var status = await Permission.notification.status;
//     if (!status.isGranted) {
//       await Permission.notification.request();
//     }
//   }
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupNotificationChannels();
//
//   var initializationSettingsAndroid =
//   const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       navigatorKey.currentState?.push(MaterialPageRoute(
//         builder: (_) => AuthScreen(),
//       ));
//     },
//   );
//
//   FirebaseMessaging firebaseFCM = FirebaseMessaging.instance;
//
//   firebaseFCM.getToken().then((token) {
//     print("📲 FCM Token: $token");
//     sendTokenToServer(token);
//   });
//
//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//     print("🔄 Updated FCM Token: $newToken");
//     sendTokenToServer(newToken);
//   });
//
//   if (Platform.isIOS) {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("🔔 Foreground Notification: ${message.notification?.title}");
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             "messages_channel",
//             "Chat Messages",
//             channelDescription: "This channel is used for chat messages notifications.",
//             importance: Importance.max,
//             priority: Priority.high,
//             largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//           ),
//          // iOS: DarwinNotificationDetails(),
//         ),
//       );
//     }
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("📨 Notification Clicked: ${message.notification?.title}");
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(
//         builder: (_) => AuthScreen(),
//       ),
//     );
//   });
//
//   runApp(MyApp());
// }
//
// void sendTokenToServer(String? token) {
//   if (token != null) {
//     print("🚀 Sending token to server: $token");
//   }
// }
//
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           return AuthScreen();
//         },
//       ),
//     );
//   }
// }
