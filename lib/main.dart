import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/firebase/firebase_options.dart';

import 'common/provider/route_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('background meessage.. ${message.notification!.body}');
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  // 데이터는 details.payload 방식으로 전달
  print('backgroundHandler');
  print(details.payload);
}

void initializeNotification() async {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        'high_importance_channel',
        'high_importance_notification',
        importance: Importance.max,
      ));

  await flutterLocalNotificationPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    ),
    // Foreground
    onDidReceiveNotificationResponse: (detail) {
      // detail: listen 함수에서 payload로 넘겨준 데이터
      // 추가 액션 정의
      print('onDidReceiveNotificationResponse');
      print(detail);
    },
    // Android Background, Android Terminated, iOS Terminated
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Android & iOS Foreground 일 때
  // localNotification을 사용해야함
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data["data"]);
    }
  });

  // Android Background, Android Terminated, iOS Terminated
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print('Android Background, Android Terminated, iOS Terminated');
    print(message);
  }

  // iOS Background
  if (Platform.isIOS) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 액션 추가
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();
  FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );
  print('fcmToken: $fcmToken');

  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
        fontFamily: 'Pretendard',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
