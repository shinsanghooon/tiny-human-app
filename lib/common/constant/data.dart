import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const storage = FlutterSecureStorage();

final emulatorIp = '10.0.2.2.:8080';
final simulatorIp = '127.0.0.1:8080';
final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

const APP_TITLE = "TINY HUMAN";

const S3_ALBUM_BASE_URL =
    "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/";

const SAMPLE_BABY_IMAGE_URL =
    "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/baby/1/album/c9f17d33-39c7-42ba-90d6-0315aa4ee3c5_image_picker_8BDAAE8F-9811-438F-9601-2E3E2DFCE08A-12553-000078B129855C8D.jpg";

const SAMPLE_IMAGES = [
  'https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/baby/1/album/7d00d46b-d18d-43d5-a81d-615301c3797d_image_picker_443F1A51-E629-4EFE-8337-81EFF3C1A785-12553-000078B129637420.jpg',
  "https://tiny-human-dev.s3.ap-northeast-2.amazonaws.com/baby/1/album/17d571be-f42a-4048-b807-918e35879eb3_image_picker_68B5436E-90EE-435B-9E55-082CF6EFCF84-12553-000078B129A57810.jpg"
];

const SAMPLE_SENTENCES = [
  "젖을 먹다가 힘든지 막 울기도 했다. 그래도 아기를 안는 것이 점점 익숙해진다. 젖은 잘 빨지 않는다. 벌써 우유병에 익숙해진 것 같다. 옆에 다른 아기들은 엄마가 오면 일단은 젖을 빨고 보다가 힘들면 울고 또 다음 수유콜에 똑같이 반복하곤 하는데, 리카는 잘 속지 않고 이제는 젖을 물리면 바로 울어버린다. 영리하다고 좋아해야 하나…",
  "처음으로 유축을 했다. 상훈이 말로는 간호사가 지난 번에 유축기를 빌려줄지 물어봤는데 내가 거절을 했다고 하는데 전혀 기억이 나질 않는다. 대여가 되는 줄 알았다면 진작에 줄걸 초유를 며칠이나 놓친 것 같아 내 자신에게 너무 화가 나고 바보 같다는 자책이 들었다. 그래도 막상 유축을 해 보니 노란 초유가 나오는 게 아직 완전히 늦지는 않은 것 같아서 그나마 다행이다. 직수는 어려우니 이렇게라도 초유를 최대한 먹여야겠다. 그래도 내 가슴에서 젖이 나온다는 게 신기하기도 하고 뿌듯하기도 하다.",
];
