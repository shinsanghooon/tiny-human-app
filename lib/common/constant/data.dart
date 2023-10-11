import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const storage = FlutterSecureStorage();

final emulatorIp = '10.0.2.2.:8080';
final simulatorIp = '127.0.0.1:8080';
final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;