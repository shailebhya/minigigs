
// import 'package:easily/services/constants.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class NotifCtrl extends GetxController{
//   Future<void> onBackgroundMessage(RemoteMessage message) async {
//   final chatClient = StreamChatClient(apiKey);

//   chatClient.connectUser(
//     User(id: userId),
//     userToken,
//     connectWebSocket: false,
//   );

//   handleNotification(message, chatClient);
// }

// void handleNotification(
//   RemoteMessage message,
//   StreamChatClient chatClient,
// ) async {

//   final data = message.data;

//   if (data['type'] == 'message.new') {
//     final flutterLocalNotificationsPlugin = await setupLocalNotifications();
//     final messageId = data['id'];
//     final response = await chatClient.getMessage(messageId);
    
//     flutterLocalNotificationsPlugin.show(
//       1,
//       'New message from ${response.message.user.name} in ${response.channel.name}',
//       response.message.text,
//       NotificationDetails(
//           android: AndroidNotificationDetails(
//         'new_message',
//         'New message notifications channel',
//       )),
//     );
//   }
// }

// FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
// }