import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../core/res/colors.dart';
import '../core/res/styles.dart';
import '../core/res/spacing.dart';
import '../core/res/images.dart';
import '../locator.dart';
import '../services/appconfig_service.dart';
import '../ui/widgets/button.dart';

class UpdateChecker {
  versionCheck() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String currentVersion = info.version;

    try {
      final AppConfig appConfig = locator<AppConfigService>().config;

      final String version =
          Platform.isAndroid
              ? appConfig.android?.version ?? ''
              : appConfig.iOS?.version ?? '';

      final String url =
          Platform.isAndroid
              ? appConfig.android?.url ?? ''
              : appConfig.iOS?.url ?? '';

      if (version.isEmpty || url.isEmpty) return;

      final int remoteVersion = int.parse(version.replaceAll(".", ""));
      final int localVersion = int.parse(currentVersion.replaceAll(".", ""));

      print("remoteVersion $remoteVersion");
      print("localVersion $localVersion");

      if (remoteVersion > localVersion) {
        // && (appConfig.forceUpdate ?? false)
        print("TRUEEEE");
        await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //       SvgPicture.asset(Images.updateIcon),
                  VerticalSpacing.custom(value: 24),
                  Text("Update Available"),
                  VerticalSpacing.custom(value: 12),
                  const Text(
                    "Please update the app for better experience",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff414141),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  VerticalSpacing.custom(value: 20),
                  Button(
                    "Update",
                    key: UniqueKey(),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Get.back(); // Close dialog
                    },
                  ),
                  VerticalSpacing.custom(value: 12),
                  Button(
                    "Cancel",
                    key: UniqueKey(),
                    color: AppColor.divider,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff312D4A),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                    },
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    } catch (exception, stacktrace) {
      // Logger.e("Unable to check for version info", e: exception, s: stacktrace);
      print("Version check failed $stacktrace");
    }
  }
}
