import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
  @override
  void initState() {
    
    super.initState();
     subscribeToTopic('KarimAhmed');
    Supabase.instance.client.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        // Request permissions for push notifications
        await FirebaseMessaging.instance.requestPermission();
        // get Apple token
        await FirebaseMessaging.instance.getAPNSToken();
        final fcmToken = await FirebaseMessaging.instance.getToken();
        log(fcmToken.toString());
        if (fcmToken != null) {
          await _setFcmToken(fcmToken);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title} : ${notification.body}'),
          ),
        );
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) async {
      await _setFcmToken(fcmToken);
    });
  }

  Future<void> _setFcmToken(String fcmToken) async {
    final userID = Supabase.instance.client.auth.currentUser?.id;
    if (userID != null) {
      await Supabase.instance.client.from('profiles').upsert({
        'id': userID,
        'fcm_token': fcmToken,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var client = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async{
                var headers = {
  'Authorization': 'Bearer ya29.a0AXooCgvLzHyA2ESHIAxsPKrMWT9anuxGHskR9u4WyKgvJ8zhn4g2EYKG1Ax5Rz5d9_JXMRYhNYN--Y5Ps9CqElktLeXZ2a10iZcZY1-0dYU_ehW3NvO0GKTXSuRasgB0VeAitx0zii1UjWbzOfJa2W_P2HYGQA9WY069aCgYKAQQSARMSFQHGX2MifjqIM1-fHtMKk9_abx_41g0171',
  'Content-Type': 'application/json'
};
var data = json.encode({
  "message": {
    "topic": "KarimAhmed",
    "notification": {
      "title": "Topic Sample Title",
      "body": "This is  a Topic sample notification"
    },
    "data": {
      "key1": "value1",
      "key2": "value2"
    }
  }
});
var dio = Dio();
var response = await dio.request(
  'https://fcm.googleapis.com/v1/projects/notification-supabase/messages:send',
  options: Options(
    method: 'POST',
    headers: headers,
  ),
  data: data,
);

if (response.statusCode == 200) {
  print(json.encode(response.data));
}
else {
  print(response.statusMessage);
}
              },
              child: Text('Home'),
            ),
            Text(
              client.auth.currentUser?.emailConfirmedAt ?? "Not Verified",
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              client.auth.currentUser?.userMetadata?["name"] ?? "Not Verified",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
