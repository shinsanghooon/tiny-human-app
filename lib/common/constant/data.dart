import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const storage = FlutterSecureStorage();

final emulatorIp = '10.0.2.2.:8080';
final simulatorIp = '127.0.0.1:8080';
final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

const APP_TITLE = "TINY HUMAN";

const SAMPLE_BABY_IMAGE_URL =
    "https://images.unsplash.com/photo-1519689680058-324335c77eba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3477&q=80";
