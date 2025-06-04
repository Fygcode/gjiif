import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                          left: 20,
                          right: 20,
                          child: _buildUpdatesWidget(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Upcoming Events",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                      ),
                      itemCount: controller.gridImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print("=====INDEX $index");
                            Get.to(() => EventDetailScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            // Add padding here
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              controller.gridImages[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 25,
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            controller.quotes[controller
                                .currentQuoteIndex
                                .value],
                            key: ValueKey(controller.currentQuoteIndex.value),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
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
                controller.bannerImages.map((url) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) => Image.asset(
                            'assets/updateBanner.png',
                            fit: BoxFit.cover,
                          ),
                    ),
                  );
                }).toList(),
            options: CarouselOptions(
              height: 400,
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
