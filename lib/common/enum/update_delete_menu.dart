import 'package:flutter/material.dart';

enum DiaryUpdateDeleteMenu {
  UPDATE('update', '일기 수정', Icons.note_alt_outlined),
  DELETE('delete', '일기 삭제', Icons.delete_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const DiaryUpdateDeleteMenu(this.name, this.displayName, this.disPlayIcon);
}

enum AlbumPopUpMenu {
  DELETE('delete', '앨범 삭제', Icons.delete_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const AlbumPopUpMenu(this.name, this.displayName, this.disPlayIcon);
}

enum BabyUpdateDeleteMenu {
  UPDATE('update', '아기 정보 수정', Icons.note_alt_outlined),
  DELETE('delete', '아기 삭제', Icons.delete_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const BabyUpdateDeleteMenu(this.name, this.displayName, this.disPlayIcon);
}
