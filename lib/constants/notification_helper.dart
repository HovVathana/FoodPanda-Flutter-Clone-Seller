// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationHelper {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<String> getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       return token;
//     });
//     return '';
//   }

//   void saveToken() async {
//     String token = await getToken();
//     await firestore
//         .collection('tokens')
//         .doc(firebaseAuth.currentUser!.uid)
//         .set({
//       'token': token,
//     });
//   }

//   // void requestPermission() async {
//   //   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   //   NotificationSettings settings = await messaging.requestPermission(
//   //     alert: true,
//   //     announcement: false,
//   //     badge: true,
//   //     carPlay: false,
//   //     criticalAlert: false,
//   //     provisional: false,
//   //     sound: true,
//   //   );

//   //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//   //     print('User granted permission');
//   //   } else if (settings.authorizationStatus ==
//   //       AuthorizationStatus.provisional) {
//   //     print('User granted provisional permission');
//   //   } else {
//   //     print('User declined or has not accepted permission');
//   //   }
//   // }

//   void requestPermission() async {
//     await Permission.notification.isDenied.then((value) {
//       if (value) {
//         Permission.notification.request();
//       }
//     });
//     await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }

//   void loadFCM() async {
//     if (!kIsWeb) {
//       var channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         importance: Importance.high,
//         enableVibration: true,
//       );

//       var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }

//   void listenFCM() async {
//     var channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       importance: Importance.high,
//       enableVibration: true,
//     );

//     var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: 'launch_background',
//             ),
//           ),
//         );
//       }
//     });
//   }

// // Future<void> sendNotification(
// //   tokens,
// //   String title,
// //   String body,
// //   String imageUrl,
// // ) async {
// //   FirebaseFunctions functions =
// //       FirebaseFunctions.instanceFor(region: 'us-central1');

// //   try {
// //     final HttpsCallable callable = functions.httpsCallable('sendNotification');
// //     final response = await callable.call({
// //       'tokens': tokens,
// //       'title': title,
// //       'body': body,
// //       'imageUrl': imageUrl,
// //     });

// //     print('Message sent: ${response.data}');
// //   } catch (e) {
// //     print('Error sending message: $e');
// //   }
// // }
// }
