import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../controllers/master_data_controller.dart';
import '../../../locator.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/network_service.dart';
import '../terms/terms_screen.dart';

// class SplashController extends GetxController {
//
//   var isLoading = true.obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     init();
//   }
//
//   /// Initial method called on splash screen load
//   Future<void> init() async {
//     print("INSIDE INIT SPLASH CONTROLLER");
//     // Simulate a short loading time (splash delay)
//     await Future.delayed(const Duration(seconds: 2));
//
//     // Optionally fetch data or check login state
//     // await fetchUserData();
//
//     // Navigate to dashboard (or login depending on logic)
//     Get.off(() => TermsScreen());
//     // OR Get.offNamed('/dashboard');
//   }
//
// }


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      debugPrint("🚀 Splash init started");

      // // Small splash delay (optional UX)
      // await Future.delayed(const Duration(seconds: 1));

      await _loadRemoteConfig();
      await _initServices();

      debugPrint("✅ App init success");

      Get.offAll(() => TermsScreen());
      // OR Get.offAllNamed('/login');

    } catch (e, s) {
      debugPrint("❌ Splash init failed: $e");
      debugPrint("$s");

      Get.snackbar(
        'Startup Error',
        'Unable to initialize app',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

Future<void> _loadRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setDefaults({'config': '{}'});

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 2),
      minimumFetchInterval: Duration.zero,
    ),
  );

  await remoteConfig.fetchAndActivate();

  final rawJson = remoteConfig.getString('config');
  if (rawJson.isNotEmpty && rawJson != '{}') {
    locator<AppConfigService>().setConfig(jsonDecode(rawJson));
  }
}

Future<void> _initServices() async {
  locator<NetworkService>().onInit();

  final masterData = Get.find<MasterDataController>();
  await masterData.loadInitialData();
}


