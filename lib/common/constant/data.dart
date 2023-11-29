import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiny_human_app/diary/enum/file_type.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_sentence_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const storage = FlutterSecureStorage();

final emulatorIp = '10.0.2.2.:8080';
final simulatorIp = '127.0.0.1:8080';
final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

const APP_TITLE = "TINY HUMAN";

const S3_BASE_URL =
    "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/";

const SAMPLE_BABY_IMAGE_URL =
    "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/baby/1/album/c9f17d33-39c7-42ba-90d6-0315aa4ee3c5_image_picker_8BDAAE8F-9811-438F-9601-2E3E2DFCE08A-12553-000078B129855C8D.jpg";

var SAMPLE_IMAGES = [
  DiaryPictureModel(id: 1, isMainPicture: true, contentType: FileType.PHOTO, keyName: "baby/1/album/7d00d46b-d18d-43d5-a81d-615301c3797d_image_picker_443F1A51-E629-4EFE-8337-81EFF3C1A785-12553-000078B129637420.jpg"),
];

var SAMPLE_SENTENCES = [
  SentenceRequestModel(sentence: "젖을 먹다가 힘든지 막 울기도 했다. 그래도 아기를 안는 것이 점점 익숙해진다. 젖은 잘 빨지 않는다. 벌써 우유병에 익숙해진 것 같다. 옆에 다른 아기들은 엄마가 오면 일단은 젖을 빨고 보다가 힘들면 울고 또 다음 수유콜에 똑같이 반복하곤 하는데, 리카는 잘 속지 않고 이제는 젖을 물리면 바로 울어버린다. 영리하다고 좋아해야 하나…"),
];
