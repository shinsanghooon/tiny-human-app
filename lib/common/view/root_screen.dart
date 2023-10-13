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
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Center(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              MainMenuItemButton(menuItemName: 'BABY', screen: AlbumScreen()),
              MainMenuItemButton(menuItemName: 'DIARY', screen: AlbumScreen()),
              MainMenuItemButton(menuItemName: 'ALBUM', screen: AlbumScreen()),
              MainMenuItemButton(menuItemName: 'HELP', screen: AlbumScreen()),
              MainMenuItemButton(menuItemName: 'SETTINGS', screen: AlbumScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
