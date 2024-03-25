import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const FCM_TOKEN = 'FCM_TOKEN';

const storage = FlutterSecureStorage();

final emulatorIp = 'http://10.0.2.2:8080';
final simulatorIp = 'http://127.0.0.1:8080';
// final emulatorIp = 'https://api.tinyhuman.today';
// final simulatorIp = 'https://api.tinyhuman.today';

final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

const APP_TITLE = "TINY HUMAN";

const S3_BASE_URL = "https://tiny-human-thumbnail-dev.s3.ap-northeast-2.amazonaws.com/";

const SAMPLE_BABY_IMAGE_URL =
    "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/baby/1/album/c9f17d33-39c7-42ba-90d6-0315aa4ee3c5_image_picker_8BDAAE8F-9811-438F-9601-2E3E2DFCE08A-12553-000078B129855C8D.jpg";
