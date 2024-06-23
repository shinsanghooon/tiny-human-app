import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/user/provider/user_me_provider.dart';

import '../../common/layout/default_layout.dart';
import '../model/user_model.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool isChatPushAllowed = true;
  bool isDiaryPushAllowed = true;

  @override
  Widget build(BuildContext context) {
    print(isDiaryPushAllowed);
    print(isChatPushAllowed);
    print('----');

    final user = ref.watch(userMeProvider) as UserModel;

    return DefaultLayout(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w800,
          ),
        ),
        toolbarHeight: 64.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mainProfile(user.email),
            dividerWithPadding(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('알림 설정',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    )),
                InkWell(
                  onTap: () {
                    AppSettings.openAppSettings(type: AppSettingsType.notification);
                  },
                  child: const Text(
                    '설정화면 이동',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            dividerWithPadding(),
            notificationDetailToggle("일기 알림", isDiaryPushAllowed, (value) {
              setState(() {
                isDiaryPushAllowed = value;
              });
            }),
            dividerWithPadding(),
            notificationDetailToggle("채팅 알림", isChatPushAllowed, (value) {
              setState(() {
                isChatPushAllowed = value;
              });
            }),
            dividerWithPadding(),
            InkWell(
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                ref.read(userMeProvider.notifier).logout();
              },
            ),
            dividerWithPadding(),
          ],
        ),
      ),
    );
  }

  Row notificationDetailToggle(String title, bool switchValue, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Platform.isIOS
            ? CupertinoSwitch(
                value: switchValue,
                key: ValueKey(title),
                activeColor: CupertinoColors.activeBlue,
                onChanged: (bool? value) {
                  onChanged(value ?? false);
                },
              )
            : Switch(
                value: switchValue,
                key: ValueKey(title),
                onChanged: onChanged,
              ),
      ],
    );
  }

  Widget dividerWithPadding() {
    return const Column(
      children: [
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget mainProfile(String email) {
    return Row(
      children: [
        // 프로필 사진
        CircleAvatar(
          radius: 40.0, // CircleAvatar 크기
          child: Padding(
            padding: const EdgeInsets.all(8.0), // 내부 여백을 추가하여 이미지 크기 조절
            child: Image.asset(
              'asset/images/logo.png',
              fit: BoxFit.cover,
              width: 54.0,
              height: 54.0,
            ),
          ),
        ),
        const SizedBox(width: 16.0), // 사진과 이메일 사이의 간격
        // 사용자 이메일
        Text(
          email,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
