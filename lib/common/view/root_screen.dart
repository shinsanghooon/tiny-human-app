import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/checklist/view/checklist_screen.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/diary/view/diary_screen.dart';
import 'package:tiny_human_app/help/view/help_screen.dart';
import 'package:tiny_human_app/user/view/setting_screen.dart';

class RootScreen extends StatefulWidget {
  static String get routeName => 'home';

  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  // late 나중에 이 값을 부를 때는 이미 선언이 되어 있을 것이야.
  // ?를 달아버리면 컨트롤러를 쓸 때마다 null 처리를 해줘야한다.
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();

    // vsync
    // 렌더링 엔진에서 필요한 것 컨트롤러를 선언하는 현재 스테이트를 넣어주면 된다.
    // this가 특정 기능을 가지고 있어야 한다.
    // SingleTickerProviderStateMixin를 넣어주고 this를 해줘야한다.
    controller = TabController(length: 5, vsync: this);

    // 컨트롤러에서 변화가 있을 때마다 tabListener 함수를 실행한다.
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_outlined),
              label: 'Album',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mark_chat_unread_outlined),
              label: 'Help Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              label: 'Checklist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
        ),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            DiaryScreen(),
            AlbumScreen(),
            HelpScreen(),
            CheckListScreen(),
            SettingScreen(),
          ],
        ));
  }
}
