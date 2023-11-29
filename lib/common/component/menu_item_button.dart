import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MainMenuItemButton extends StatelessWidget {
  final String menuItemName;
  final Widget screen;
  final IconData menuItemIcon;
  final double customFontSize;

  const MainMenuItemButton({
    required this.menuItemName,
    required this.screen,
    required this.menuItemIcon,
    this.customFontSize = 16.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        height: MediaQuery.of(context).size.width / 3.5,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 30,
              offset: Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 30,
              offset: Offset(-5, -5),
            )
          ],
        ),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => screen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: PRIMARY_COLOR,
              elevation: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  menuItemIcon,
                  size: 36.0,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  menuItemName,
                  style: TextStyle(
                    fontSize: customFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
