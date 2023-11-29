import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:tiny_human_app/checklist/view/checklist_screen.dart';
import 'package:tiny_human_app/common/component/menu_item_button.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/user/view/setting_screen.dart';
import 'package:tiny_human_app/diary/view/diary_screen.dart';
import 'package:tiny_human_app/help/view/help_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: SafeArea(
        bottom: false,
        top: false,
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35.0),
                child: Text(
                  APP_TITLE,
                  style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.w900,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainMenuItemButton(
                    menuItemName: 'BABY',
                    menuItemIcon: Icons.child_care_outlined,

                    screen: BabyScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'DIARY',
                    menuItemIcon: Icons.event_note_outlined,
                    screen: DiaryScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'ALBUM',
                    menuItemIcon: Icons.photo_outlined,
                    screen: AlbumScreen(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainMenuItemButton(
                    menuItemName: 'HELP',
                    menuItemIcon: Icons.mark_chat_unread_outlined,
                    screen: HelpScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'CHECK-LIST',
                    customFontSize: 12.0,
                    menuItemIcon: Icons.check_box_outlined,
                    screen: CheckListScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'SETTINGS',
                    customFontSize: 14.0,
                    menuItemIcon: Icons.settings_outlined,
                    screen: SettingScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
