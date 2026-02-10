
import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tjw1/router.dart';
import 'package:tjw1/services/appconfig_service.dart';
import 'package:tjw1/services/network_service.dart';
import 'package:tjw1/ui/views/payment/payment_controller.dart';
import 'package:toastification/toastification.dart';





import 'controllers/master_data_controller.dart';
import 'core/res/colors.dart';
import 'core/res/styles.dart';
import 'firebase_options.dart';
import 'locator.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   setupLocator();
//
//   try {
//     // Fetch config from Firebase Remote Config
//     final remoteConfig = FirebaseRemoteConfig.instance;
//
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 10),
//       minimumFetchInterval: const Duration(seconds: 0),
//     ));
//
//     await remoteConfig.fetchAndActivate();
//
//     final rawJson = remoteConfig.getString('config');
//     debugPrint('Remote config raw: $rawJson');
//     final Map<String, dynamic> configMap = jsonDecode(rawJson);
//
//     // Set App Config into service
//     locator<AppConfigService>().setConfig(configMap);
//   } catch (e) {
//     debugPrint('Failed to fetch or decode remote config: $e');
//   }
//
//   // Init network service (after config is set)
//   locator<NetworkService>().onInit();
//   final masterData = Get.put(MasterDataController());
//   await masterData.loadInitialData();
//
//   // Run the app
//   //  runApp(MyApp());
//
//   Get.put<PaymentController>(
//     PaymentController(),
//     permanent: true,
//   );
//
//   runApp(
//     const ToastificationWrapper(
//       child: MyApp(),
//     ),
//   );
//   // runApp(
//   //   DevicePreview(
//   //     enabled: !kReleaseMode,
//   //     builder: (context) => MyApp(),
//   //   ),
//   // );
// }

// =============================

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   setupLocator();
//
//   runApp(
//     const ToastificationWrapper(
//       child: BootstrapApp(),
//     ),
//   );
// }
//
// class BootstrapApp extends StatefulWidget {
//   const BootstrapApp({super.key});
//
//   @override
//   State<BootstrapApp> createState() => _BootstrapAppState();
// }
//
// class _BootstrapAppState extends State<BootstrapApp> {
//   bool _ready = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   Future<void> _init() async {
//     await _loadRemoteConfig();
//     await _initServices();
//     setState(() => _ready = true);
//   }
//
//   Future<void> _loadRemoteConfig() async {
//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;
//
//       await remoteConfig.setDefaults({
//         'config': '{}',
//       });
//
//       await remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 5),
//           minimumFetchInterval: Duration.zero,
//         ),
//       );
//
//       final updated = await remoteConfig.fetchAndActivate();
//
//       debugPrint('RemoteConfig updated: $updated');
//
//       final rawJson = remoteConfig.getString('config');
//       debugPrint('RemoteConfig raw: $rawJson');
//
//       if (rawJson.isNotEmpty && rawJson != '{}') {
//         locator<AppConfigService>().setConfig(jsonDecode(rawJson));
//       }
//     } catch (e, s) {
//       debugPrint('Remote config failed: $e');
//       debugPrint('$s');
//     }
//   }
//
//
//   Future<void> _initServices() async {
//     locator<NetworkService>().onInit();
//
//     Get.put(PaymentController(), permanent: true);
//
//     final masterData = Get.put(MasterDataController());
//     await masterData.loadInitialData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_ready) {
//       return const MaterialApp(
//         home: Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         ),
//       );
//     }
//
//     return MyApp();
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//
//     return GetMaterialApp(
//       title: 'GJIIF',
//       initialRoute: '/',  //  / ,  login
//       debugShowCheckedModeBanner: false,
//       getPages: AppRoutes.pages,
//       theme: AppStyle.appTheme,
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//     );
//   }
// }


// ================ WORKING - WHITE SCREEN ISSUE ================
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   setupLocator();
//
//   await _loadRemoteConfig();
//   await _initServices();
//
//   runApp(
//     const ToastificationWrapper(
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//
//     return GetMaterialApp(
//       title: 'GJIIF',
//       initialRoute: '/',  //  / ,  login
//       debugShowCheckedModeBanner: false,
//       getPages: AppRoutes.pages,
//       theme: AppStyle.appTheme,
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//     );
//   }
// }
//
// Future<void> _loadRemoteConfig() async {
//   final remoteConfig = FirebaseRemoteConfig.instance;
//
//   await remoteConfig.setDefaults({'config': '{}'});
//
//   await remoteConfig.setConfigSettings(
//     RemoteConfigSettings(
//       fetchTimeout: Duration(seconds: 5),
//       minimumFetchInterval: Duration.zero,
//     ),
//   );
//
//   await remoteConfig.fetchAndActivate();
//
//   final rawJson = remoteConfig.getString('config');
//   if (rawJson.isNotEmpty && rawJson != '{}') {
//     locator<AppConfigService>().setConfig(jsonDecode(rawJson));
//   }
// }
//
// Future<void> _initServices() async {
//   locator<NetworkService>().onInit();
//
//   Get.put(PaymentController(), permanent: true);
//
//   final masterData = Get.put(MasterDataController());
//   await masterData.loadInitialData();
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(
    const ToastificationWrapper(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return GetMaterialApp(
      title: 'GJIIF',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppRoutes.pages,
      theme: AppStyle.appTheme,
    );
  }
}

