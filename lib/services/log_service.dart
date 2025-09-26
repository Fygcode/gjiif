// lib/utils/logging_utils.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


Future<void> logErrorToBackend({
  required String error,
  required String screen,
  StackTrace? stackTrace,
}) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    final logData = {
      "message": error,
      "stackTrace": stackTrace?.toString() ?? "",
      "timestamp": DateTime.now().toIso8601String(),
      "screen": screen,
  //    "userId": Get.find<AuthController>().userId,
      "appVersion": appVersion,
      "platform": Platform.operatingSystem,
      "env": const String.fromEnvironment("ENV", defaultValue: "prod"),
    };

  //  await ApiService.post('/log-error', body: logData);
  } catch (logError) {
    print('Failed to log error: $logError');
  }
}
