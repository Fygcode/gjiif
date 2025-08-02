import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/enum/view_state.dart';
import '../../../core/res/colors.dart';
import '../event_detail/event_detail_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  Future<void> _onRefresh(BuildContext context) async {
    bool refreshed = await controller.refreshRemoteConfig();
    if (refreshed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TapOutsideUnFocus(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Background image
                        Image.asset(
                          "assets/pattern.png",
                          height: size.height * 0.58,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        // Gradient transition at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 250,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white24,
                                  AppColor.background,
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 20,
                          left: 10,
                          right: 10,
                          child: _buildUpdatesWidget(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Pre Register ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Obx(
                      () => Column(
                        children:
                            controller.eventList.map((event) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => EventDetailScreen(),
                                      arguments: event.eventID
                                    ); // if needed
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.border.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 100,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Image.network(
                                              event.eventLogo!,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(Icons.broken_image),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.eventName ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.date_range,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(event.date ?? ''),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(event.venue ?? ''),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 25),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [AppColor.gradient1, AppColor.gradient2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  "Today’s South India Rates",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff581728),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Date and Time Row (you can optionally make this dynamic too)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/calender.svg",
                                      color: AppColor.textPrimary,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      DateFormat(
                                        'EEE, MMM dd, yyyy',
                                      ).format(controller.rateDatetime ?? DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        color: AppColor.textPrimary,
                                      ),
                                    ),
                                    SvgPicture.asset("assets/clock.svg"),
                                    SizedBox(width: 6),
                                    Text.rich(
                                      controller.rateDatetime != null
                                          ? TextSpan(
                                            text: DateFormat(
                                              'hh:mm ',
                                            ).format(controller.rateDatetime!),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: DateFormat('a').format(
                                                  controller.rateDatetime!,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                          : TextSpan(
                                            text: '',
                                          ), // fallback if null
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Dynamic Rate Cards
                              ...controller.rateCardDataList.map((rate) {
                                final isSilver =
                                    rate.metalCategory?.toLowerCase() ==
                                    "silver";
                                final imageAsset =
                                    isSilver
                                        ? "assets/silver.svg"
                                        : "assets/gold.svg";
                                final gradientColors =
                                    isSilver
                                        ? [
                                          AppColor.gradient3,
                                          AppColor.gradient4,
                                        ]
                                        : [
                                          AppColor.gradientGold1,
                                          AppColor.gradientGold2,
                                        ];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          top: 10,
                                          right: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: LinearGradient(
                                            colors: gradientColors,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 6,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    rate.metal!,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff151515),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 9),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColor.textPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "${rate.grams} Gms",
                                                      style: TextStyle(
                                                        color: AppColor.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Price
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 5,
                                                bottom: 10,
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/priceHigh.svg",
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "₹ ${rate.rate}",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  rate.isGSTIncluded == 0
                                                      ? Text(
                                                        "Excl. ${rate.gstPercentage}% GST",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColor.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: SvgPicture.asset(
                                          imageAsset,
                                          height: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUpdatesWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => CarouselSlider(
            items:
                controller.bannerImages.map((path) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                  //    color: Colors.white.withOpacity(0.9),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:

                    CachedNetworkImage(
                      imageUrl: path,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      // placeholder: (context, url) => const Center(
                      //   child: CircularProgressIndicator(),
                      // ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),

                    // Image.network(
                    //   path,
                    //   fit: BoxFit.contain,
                    //   alignment: Alignment.center,
                    // ),
                  );
                }).toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.5,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                controller.currentImageIndex.value = index;
              },
            ),
          ),
        ),

        const SizedBox(height: 15),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.bannerImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: controller.currentImageIndex.value == index ? 10 : 8,
                height: controller.currentImageIndex.value == index ? 10 : 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      controller.currentImageIndex.value == index
                          ? AppColor.primary
                          : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

}
