import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/user/provider/user_me_provider.dart';

import '../../common/layout/default_layout.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(userMeProvider.notifier).logout();
          },
          child: Text('로그아웃'),
        ),
      ),
    );
  }
}
