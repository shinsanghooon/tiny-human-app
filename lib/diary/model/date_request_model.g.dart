// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateRequestModel _$DateRequestModelFromJson(Map<String, dynamic> json) =>
    DateRequestModel(
      updatedDate: DateTime.parse(json['updatedDate'] as String),
    );

Map<String, dynamic> _$DateRequestModelToJson(DateRequestModel instance) =>
    <String, dynamic>{
      'updatedDate': instance.updatedDate.toIso8601String(),
    };
