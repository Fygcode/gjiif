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
  Rx<SectionType> selectedSection = SectionType.updates.obs;
  final RxInt selectedChipIndex = 0.obs;
  RxList<String> bannerImages = <String>[].obs;

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

  RxInt currentQuoteIndex = 0.obs;
  Timer? _timer;

  RxInt currentImageIndex = 0.obs;

  // Products
  var products = <Products>[].obs;
  var isLoading = true.obs;

  // TextEditingControllers
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  // Form
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController fruitController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Focus nodes
  FocusNode focusNode = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  // Fruits
  final List<Fruit> fruits = [
    Fruit('Apple'),
    Fruit('Banana'),
    Fruit('Cherry'),
    // More...
  ];

  final List<String> gridImages = [
    'assets/event_gjiif.png',
    'assets/apgjf.png',
    'assets/theJewelry.png',
    'assets/event_kijf.png',
    'assets/hijs.png',
    'assets/cjs.png',
  ];

  final List<VoidCallback> onTapHandlers = [
    () => print('Tapped on GJIIF'),
    () => print('Tapped on JJS'),
    () => print('Tapped on IIJS'),
    () => print('Tapped on Vicenza'),
    () => print('Tapped on Dubai'),
    () => print('Tapped on Bangkok'),
  ];

  @override
  void onInit() {
    super.onInit();

    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        currentQuoteIndex.value = (currentQuoteIndex.value + 1) % quotes.length;
      });
    }

    // Load banners from remote config if available, else fallback to default
    print("======== ${config.banners}");
    updateBanners();
  }

  void updateBanners() {
    bannerImages.clear();
    if (config.banners != null && config.banners!.isNotEmpty) {
      bannerImages.assignAll(config.banners!);
    } else {
      print("Empty");
      bannerImages.assignAll([
        "https://img.tradeindia.com/new_website1/tradeshowslandingpage/thejewelleryshow/new-banner.jpg",
        "https://shivamjewelsandart.com/public/frontend/assets/images/inner-banner/exhibition-banner.png",
        "https://www.jewellermagazine.com/dbimages/156000/156442/156442-950px.png?m=133655721260000000",
      ]);
    }
    update();
  }


  void startBannerAutoSlide() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (Get.isRegistered<HomeController>()) {
        currentImageIndex.value =
            (currentImageIndex.value + 1) % bannerImages.length;
      } else {
        timer.cancel();
      }
    });
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

  String getDiscountPercentage(double mrpPrice, double price) {
    if (mrpPrice > price) {
      double discountPercentage = ((mrpPrice - price) / mrpPrice) * 100;
      return "${discountPercentage.toStringAsFixed(0)}%";
    } else {
      return "No Discount";
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    fruitController.dispose();
    searchFocus.dispose();
    focusNode.dispose();
    focusNodePhone.dispose();
    focusNodeEmail.dispose();
    focusNodePassword.dispose();

    _timer?.cancel();
    super.onClose();
  }

  Future<bool> refreshRemoteConfig() async {
    print("=====FFFFF");
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Optional: set shorter fetch interval on manual refresh if needed
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 0), // force fetch
      ));

      bool activated = await remoteConfig.fetchAndActivate();
      print('Remote Config refreshed: $activated');

      if (activated) {
        final rawJson = remoteConfig.getString('config');
        final Map<String, dynamic> configMap = jsonDecode(rawJson);

        // Update your config service with new config
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
