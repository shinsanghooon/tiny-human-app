import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/diary/enum/file_type.dart';

import '../../common/model/model_with_id.dart';

part 'diary_picture_model.g.dart';

@JsonSerializable()
class DiaryPictureModel implements IModelWithId {

  @override
  final int id;
  final bool isMainPicture;
  final FileType contentType;
  final String keyName;

  DiaryPictureModel({
    required this.id,
    required this.isMainPicture,
    required this.contentType,
    required this.keyName,
  });

  factory DiaryPictureModel.fromJson(Map<String, dynamic> json)
  => _$DiaryPictureModelFromJson(json);
}


