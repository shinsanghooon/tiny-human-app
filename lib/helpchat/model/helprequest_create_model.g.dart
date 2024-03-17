// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helprequest_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpRequestCreateModel _$HelpRequestCreateModelFromJson(
        Map<String, dynamic> json) =>
    HelpRequestCreateModel(
      userId: json['userId'] as int,
      requestType: json['requestType'] as String,
      contents: json['contents'] as String,
    );

Map<String, dynamic> _$HelpRequestCreateModelToJson(
        HelpRequestCreateModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'requestType': instance.requestType,
      'contents': instance.contents,
    };
