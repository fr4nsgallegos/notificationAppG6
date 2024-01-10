import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:logger/logger.dart';

class NotificationService {
  var logger = Logger();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? "-";
    print("TOKEN: $token");

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgoundMessage);
  }

  //DETECTAR EL MENSAJE CUANDO EL APP ESTA ABIERTO
  static _onMessage(RemoteMessage message) {
    if (message.notification != null) {
      Logger().d("--------------------------");
      Logger().d(message.notification!.title);
      Logger().d(message.notification!.body);
    }
  }

  static Future _onBackgoundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      Logger().d(
          "SEGUNDO PLANO ---> ${message.notification!.title} - ${message.notification!.body}");
      // print("SEGUNDO PLANO -------------------");
    }
    ;
  }
}
