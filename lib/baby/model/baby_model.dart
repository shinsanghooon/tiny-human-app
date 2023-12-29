import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BabyModel {
  final int id;
  final String name;
  final String gender;
  final String dayOfBirth;
  final int timeOfBirth;
  final String nickName;
  final String profileImgKeyName;
  final String description;

  BabyModel(
      {required this.id,
      required this.name,
      required this.gender,
      required this.dayOfBirth,
      required this.timeOfBirth,
      required this.nickName,
      required this.profileImgKeyName,
      required this.description});

  static BabyModel fromJson(Map<String, dynamic> data) {
    return BabyModel(
        id: data['id'],
        name: data['name'],
        gender: data['gender'],
        dayOfBirth: data['dayOfBirth'],
        timeOfBirth: data['timeOfBirth'],
        nickName: data['nickName'],
        profileImgKeyName: data['profileImgKeyName'],
        description: data['description']);
  }
}
