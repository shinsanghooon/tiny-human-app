import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

class RootScreen extends StatefulWidget {
  static String get routeName => 'home';

  final Widget child;

  const RootScreen({required this.child, super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with SingleTickerProviderStateMixin {
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

  int getIndex(BuildContext context) {
    if (GoRouterState.of(context).location == '/diary') {
      return 0;
    } else if (GoRouterState.of(context).location == '/album') {
      return 1;
    } else if (GoRouterState.of(context).location == '/help-chat') {
      return 2;
    } else if (GoRouterState.of(context).location == '/checklist') {
      return 3;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
          if (index == 0) {
            context.go('/diary');
          } else if (index == 1) {
            context.go('/album');
          } else if (index == 2) {
            context.go('/help-chat');
          } else if (index == 3) {
            context.go('/checklist');
          } else {
            context.go('/profile');
          }
        },
        currentIndex: getIndex(context),
        items: const [
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
      child: widget.child,
      // child: TabBarView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: controller,
      //   children: const [
      //     DiaryScreen(),
      //     AlbumScreen(),
      //     HelpChatScreen(),
      //     CheckListScreen(),
      //     SettingScreen(),
      //   ],
      // ),
    );
  }
}
