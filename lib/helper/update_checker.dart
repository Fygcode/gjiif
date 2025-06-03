// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:heavenly/services/shared/appconfig_service.dart';
//
// import 'package:package_info/package_info.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../core/model/service/alert_response.dart';
// import '../core/res/colors.dart';
// import '../core/res/images.dart';
// import '../core/res/spacing.dart';
// import '../core/res/styles.dart';
// import '../locator.dart';
// import '../services/appconfig_service.dart';
// import '../services/shared/analytics_service.dart';
// import '../services/shared/dialog_service.dart';
// import '../ui/widgets/button.dart';
// import 'logger.dart';
//
// class UpdateChecker {
//   versionCheck() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     final String currentVersion = info.version;
//
//     try {
//       final AppConfig appConfig = locator<AppConfigService>().config;
//
//       final String version = Platform.isAndroid
//           ? appConfig.android!.version!
//           : appConfig.iOS!.version!;
//
//       final String url =
//       Platform.isAndroid ? appConfig.android!.url! : appConfig.iOS!.url!;
//
//       print("Muthuraj Version");
//       print(int.parse(version.replaceAll(".", "")));
//       print(int.parse(currentVersion.replaceAll(".", "")));
//
//       if (int.parse(version.replaceAll(".", "")) >
//           int.parse(currentVersion.replaceAll(".", "")) &&
//           appConfig.forceUpdate!) {
//         locator<AnalyticsService>().logScreenName("Update dialog");
//         await showDialog(
//             context: navigationService.navigatorKey.currentState!.context,
//             barrierDismissible: true,
//             builder: (context) {
//               return AlertDialog(
//                 shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.0))),
//                 content: Container(
//                   decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SvgPicture.asset(Images.updateIcon),
//                       VerticalSpacing.custom(value: 24),
//                       Text(
//                         "Update Available",
//                         style: AppTextStyle.title,
//                       ),
//                       VerticalSpacing.custom(value: 12),
//                       const Text("Please update the app for better experience",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xff414141)),
//                         textAlign: TextAlign.center,
//                       ),
//                       VerticalSpacing.custom(value: 20),
//                       Button("Update", key: UniqueKey(),
//                           onPressed: () async {
//                             print('Open App Setting');
//                             if (await canLaunchUrl(Uri.parse(url))) {
//                               await launchUrl(Uri.parse(url));
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                             dialogService.dialogComplete(AlertResponse(status: false));
//                           }),
//                       VerticalSpacing.custom(value: 12),
//                       Button("Cancel",
//                           key: UniqueKey(),
//                           color: AppColor.iconBg,
//                           textStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xff312D4A)),
//                           onPressed: () async {
//                             dialogService.dialogComplete(AlertResponse(status: false));
//                           })
//
//                     ],
//                   ),
//                 ),
//               );
//             });
//
//       }
//     } catch (exception, stacktrace) {
//       Logger.e("Unable to check for version info", e: exception, s: stacktrace);
//     }
//   }
// }