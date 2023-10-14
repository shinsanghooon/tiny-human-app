import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/common/component/menu_item_button.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> features = ['아기', '일기', '앨범', 'HELP', '설정'];

    return DefaultLayout(
      backgroundColor: Colors.black,
      child: SafeArea(
        // bottom: false,
        // top: false,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35.0),
                child: Text(
                  "Tiny Human",
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
                    screen: AlbumScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'DIARY',
                    menuItemIcon: Icons.event_note_outlined,
                    screen: AlbumScreen(),
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
                    screen: AlbumScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'CHECK-LIST',
                    customFontSize: 13.0,
                    menuItemIcon: Icons.check_box_outlined,
                    screen: AlbumScreen(),
                  ),
                  MainMenuItemButton(
                    menuItemName: 'SETTINGS',
                    customFontSize: 13.0,
                    menuItemIcon: Icons.settings_outlined,
                    screen: AlbumScreen(),
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
