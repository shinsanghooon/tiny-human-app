import 'package:json_annotation/json_annotation.dart';

import '../../common/model/model_with_id.dart';
import '../enum/file_type.dart';

part 'diary_picture_with_presigned_model.g.dart';

@JsonSerializable()
class DiaryPictureWithPresignedModel implements IModelWithId {
  @override
  final int id;
  final bool isMainPicture;
  final FileType contentType;
  final String? fileName;
  final String keyName;
  final String? preSignedUrl;

  DiaryPictureWithPresignedModel(
      {required this.id,
      required this.isMainPicture,
      required this.contentType,
      required this.fileName,
      required this.keyName,
      required this.preSignedUrl});

  factory DiaryPictureWithPresignedModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryPictureWithPresignedModelFromJson(json);
}
