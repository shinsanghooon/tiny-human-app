import 'package:tiny_human_app/diary/enum/save_type.dart';

class PhotoWithSaveTypeModel {
  int? id;
  SaveType type;
  String path;
  String? name;

  PhotoWithSaveTypeModel({
    this.id,
    required this.type,
    required this.path,
    this.name,
  });
}
