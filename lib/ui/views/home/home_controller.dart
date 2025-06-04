import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/enum/view_state.dart';
import '../../../core/model/ecommerce/product.dart';
import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/request_method.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<String> bannerImages = <String>[].obs;
  RxInt currentQuoteIndex = 0.obs;
  RxInt currentImageIndex = 0.obs;
  Timer? _timer;

  final config = locator<AppConfigService>().config;

  final List<String> quotes = [
    "Adorn yourself with brilliance — let every jewel speak your story.",
    "More than an accessory — jewelry is a celebration of your essence.",
    "Crafted with passion, worn with pride, cherished forever.",
    "Every gem holds a memory. Every piece reflects your light.",
    "Let your elegance shine louder than words — wear timeless beauty.",
    "From whispers of gold to echoes of diamonds — express your soul.",
    "Shine isn’t just seen, it’s felt. Wear what empowers you.",
    "For moments that matter, and beauty that lasts — choose authenticity.",
    "Luxury isn’t a label, it’s a feeling — wrapped in sparkle.",
    "You don’t just wear jewelry. You wear legacy, love, and light.",
  ];

  var products = <Products>[].obs;
  final List<Fruit> fruits = [Fruit('Apple'), Fruit('Banana'), Fruit('Cherry')];

  final List<String> gridImages = [
    'assets/event_gjiif.png',
    'assets/apgjf.png',
    'assets/theJewelry.png',
    'assets/event_kijf.png',
    'assets/hijs.png',
    'assets/cjs.png',
  ];

  @override
  void onInit() {
    super.onInit();
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        currentQuoteIndex.value = (currentQuoteIndex.value + 1) % quotes.length;
      });
    }
    updateBanners();
  }

  void updateBanners() {
    bannerImages.clear();
    final newConfig = locator<AppConfigService>().config;
    if (newConfig.banners != null && newConfig.banners!.isNotEmpty) {
      bannerImages.assignAll(newConfig.banners!);
    }
    bannerImages.refresh();
  }

  Future<void> productFetch() async {
    try {
      isLoading(true);
      List<Products> response = await ApiBaseService.requestList<Products>(
        '/products',
        method: RequestMethod.GET,
      );
      products.assignAll(response);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<bool> refreshRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(seconds: 0),
        ),
      );
      bool activated = await remoteConfig.fetchAndActivate();
      if (activated) {
        final rawJson = remoteConfig.getString('config');
        final Map<String, dynamic> configMap = jsonDecode(rawJson);
        locator<AppConfigService>().setConfig(configMap);
        updateBanners();
      }
      return activated;
    } catch (e) {
      debugPrint('Failed to refresh === remote config: $e');
      return false;
    }
  }
}

class Fruit {
  final String name;

  Fruit(this.name);
}
