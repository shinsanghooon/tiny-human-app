import 'package:flutter/material.dart';

enum UpdateDeleteMenu {
  UPDATE('update', '일기 수정', Icons.note_alt_outlined),
  DELETE('delete', '일기 삭제', Icons.delete_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const UpdateDeleteMenu(this.name, this.displayName, this.disPlayIcon);
}

enum AlbumPopUpMenu {
  DELETE('delete', '앨범 삭제', Icons.delete_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const AlbumPopUpMenu(this.name, this.displayName, this.disPlayIcon);
}
