import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/firebase/firebase_options.dart';

import 'common/constant/keys.dart';
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

      // TODO
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
  // 앱이 forecground(즉, 활성 상태)에 있을 때 푸시 알림 메시지를 수신하는 경우에 호출
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    // 아래 코드를 사용하면 중복 알림이 발생한다.
    // foreground는 원래 알림이 안온다고 하던데 확인해볼 것!
    if (Platform.isAndroid) {
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
      // 앱이 백그라운드나 종료 상태에 있을 때 사용자가 푸시 알림을 탭하여 앱을 열었을 경우에 발생하는 이벤트를 처리하는 리스너
      // 액션 추가
      if (message.data['type'] == 'chat') {
        message.data['chatId'];
      } else {
        // type == help
        message.data['helpRequestId'];
      }
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();
  FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );

  runApp(
    const ProviderScope(
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
        colorScheme: const ColorScheme.light(
          primary: PRIMARY_COLOR,
          onBackground: Colors.white,
        ),
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
        dropdownMenuTheme: const DropdownMenuThemeData(
            menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          surfaceTintColor: MaterialStatePropertyAll<Color>(Colors.white),
        )),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: PRIMARY_COLOR,
        )),
        fontFamily: 'Pretendard',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        // 앱에서 지원하는 언어 목록을 설정합니다.
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
      ],
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
