// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby_model_with_presigned.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BabyModelWithPreSigned _$BabyModelWithPreSignedFromJson(
        Map<String, dynamic> json) =>
    BabyModelWithPreSigned(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String,
      dayOfBirth: json['dayOfBirth'] as String,
      timeOfBirth: json['timeOfBirth'] as int,
      nickName: json['nickName'] as String,
      profileImgKeyName: json['profileImgKeyName'] as String,
      description: json['description'] as String,
      preSignedUrl: json['preSignedUrl'] as String,
    );

Map<String, dynamic> _$BabyModelWithPreSignedToJson(
        BabyModelWithPreSigned instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'dayOfBirth': instance.dayOfBirth,
      'timeOfBirth': instance.timeOfBirth,
      'nickName': instance.nickName,
      'profileImgKeyName': instance.profileImgKeyName,
      'description': instance.description,
      'preSignedUrl': instance.preSignedUrl,
    };
