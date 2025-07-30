
import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tjw1/router.dart';
import 'package:tjw1/services/appconfig_service.dart';
import 'package:tjw1/services/network_service.dart';





import 'core/res/colors.dart';
import 'core/res/styles.dart';
import 'firebase_options.dart';
import 'locator.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   setupLocator();
//
//   locator<NetworkService>().onInit();
//
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => MyApp(),
//     ),
//   );
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup service locator
  setupLocator();

  try {
    // Fetch config from Firebase Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 0),
    ));

    await remoteConfig.fetchAndActivate();

    final rawJson = remoteConfig.getString('config');
    debugPrint('Remote config raw: $rawJson');
    final Map<String, dynamic> configMap = jsonDecode(rawJson);

    // Set App Config into service
    locator<AppConfigService>().setConfig(configMap);
  } catch (e) {
    debugPrint('Failed to fetch or decode remote config: $e');
  }

  // Init network service (after config is set)
  locator<NetworkService>().onInit();

  // Run the app
  // runApp(MyApp());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return GetMaterialApp(
      title: 'TJW',
      initialRoute: '/',  //  / ,  login
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      theme: AppStyle.appTheme,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
