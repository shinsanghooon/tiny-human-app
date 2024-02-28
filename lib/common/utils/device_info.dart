import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceUniqueId() async {
  var deviceInfo = DeviceInfoPlugin();
  String uniqueDeviceId = '';

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; //
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}'; // unique ID
  }

  return uniqueDeviceId;
}
