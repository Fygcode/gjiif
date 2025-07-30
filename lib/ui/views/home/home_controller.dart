import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tjw1/core/model/tjw/banner_event_response.dart';
import 'package:tjw1/core/model/tjw/today_rate_card.dart';

import '../../../core/enum/view_state.dart';

import '../../../locator.dart';
import '../../../services/api_base_service.dart';
import '../../../services/appconfig_service.dart';
import '../../../services/request_method.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<String> bannerImages = <String>[].obs;
  RxList<EventsList> eventList = <EventsList>[].obs;

  RxList<RateCardData> rateCardDataList = <RateCardData>[].obs;

  RxInt currentImageIndex = 0.obs;

  final config = locator<AppConfigService>().config;

  @override
  void onInit() {
    super.onInit();
    fetchBannerEvent();
    fetchRateCard();
  }

  Future<void> fetchBannerEvent() async {
    try {
      isLoading(true);
      BannerEventResponse response =
          await ApiBaseService.request<BannerEventResponse>(
            'SQ/GetBannerForHomeScreen',
            method: RequestMethod.GET,
            authenticated: false,
          );

      if (response.status == "200") {
        bannerImages.assignAll(
          response.bannerEventData?.bannerList
                  ?.map((e) => e.bannerURL ?? '')
                  .toList() ??
              [],
        );
        eventList.value = response.bannerEventData?.eventsList ?? [];
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  DateTime? rateDatetime;

  fetchRateCard() async {
    try {
      isLoading(true);
      TodaysRateCard response = await ApiBaseService.request<TodaysRateCard>(
        'SQ/TodaysRateCard',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        rateCardDataList.value = response.rateCardData ?? [];

        String rawDate = response.rateCardData!.first.rateDate ?? '';
        rateDatetime = DateTime.parse(rawDate);
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateBanners() {
    bannerImages.clear();
    final newConfig = locator<AppConfigService>().config;
    if (newConfig.banners != null && newConfig.banners!.isNotEmpty) {
      bannerImages.assignAll(newConfig.banners!);
    }
    bannerImages.refresh();
  }

  @override
  void onClose() {
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
