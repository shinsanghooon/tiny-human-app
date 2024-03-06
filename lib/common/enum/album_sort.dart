import 'package:flutter/material.dart';

enum AlbumSorting {
  UPLOAD('uploadedAt', '업로드 날짜 순', Icons.upload_outlined),
  CREATE('createdAt', '사진 찍은 날짜 순', Icons.camera_alt_outlined);

  final String name;
  final String displayName;
  final IconData disPlayIcon;

  const AlbumSorting(this.name, this.displayName, this.disPlayIcon);
}
