import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class MyFirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Variable to track changes
  static ValueNotifier<String> variableNotifier = ValueNotifier<String>('');

  static Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);
    await _localNotifications.initialize(initSettings);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground message: ${message.notification?.title}");
      _showNotification(message);
    });

    // Background & terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Opened from background: ${message.notification?.title}");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    String? token = await getToken();
    // Listen for variable changes
    variableNotifier.addListener(() {
      _sendLocalNotification(
          "Order Update", "Your order is now ${variableNotifier.value}");
      _sendPushNotification(token!, "Order Update",
          "Your order is now ${variableNotifier.value}");
    });
  }

  // Show local notification for foreground changes
  static Future<void> _sendLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await _localNotifications.show(0, title, body, details);
  }

  static Future<void> _sendPushNotification(
      String token, String title, String body) async {
    const String projectId = "shoppy-5a904";
    const String serviceAccountPath = "assets/json/service_account.json";

    try {
      // Load service account credentials
      final serviceAccountJson =
          await rootBundle.loadString(serviceAccountPath);
      final serviceAccount =
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      // Authenticate and get access token
      final client = await auth.clientViaServiceAccount(
        serviceAccount,
        ["https://www.googleapis.com/auth/firebase.messaging"],
      );

      final response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/$projectId/messages:send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${client.credentials.accessToken.data}",
        },
        body: jsonEncode({
          "message": {
            "token": token,
            "notification": {
              "title": title,
              "body": body,
            },
            "android": {
              "priority": "high",
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        log("Push Notification Sent: ${response.body}");
      } else {
        log("Error Sending Notification: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("Failed to send notification: $e");
    }
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    await _sendLocalNotification(
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "No content",
    );
  }

  static Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    log("FCM Token: $token");
    return token;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling background notification: ${message.notification?.title}");
}
