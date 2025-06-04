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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isLoading = false;

    Future<void> _onRefresh() async {
      setState(() => _isLoading = true);

      bool refreshed = await controller.refreshRemoteConfig();

      setState(() => _isLoading = false);

      if (refreshed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Updated!')));
      }
    }

    return TapOutsideUnFocus(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
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
                        child: Obx(() {
                          switch (controller.selectedSection.value) {
                            case SectionType.article:
                              return _buildArticleWidget(); // your custom widget
                            case SectionType.updates:
                              return _buildUpdatesWidget(); // your custom widget
                            case SectionType.liveRate:
                              return _buildLiveRateWidget(); // your custom widget
                          }
                        }),
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
                          padding: const EdgeInsets.all(10), // Add padding here
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
                          controller.quotes[controller.currentQuoteIndex.value],
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

                  // Continue Registration
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 12,
                  //   ),
                  //   child: Text(
                  //     "Continue registration",
                  //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                  //
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //         height: 50,
                  //         child: ListView.builder(
                  //           itemCount: 6,
                  //           scrollDirection: Axis.horizontal,
                  //           itemBuilder: (context, index) {
                  //             final isSelected = controller.selectedChipIndex.value == index;
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 print("Tapped chip $index");
                  //                 controller.selectedChipIndex.value = index;
                  //               },
                  //               child: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                   horizontal: 30,
                  //                   vertical: 8,
                  //                 ),
                  //                 decoration: BoxDecoration(
                  //                   color: isSelected ? AppColor.primary : AppColor.secondary,
                  //                   borderRadius: BorderRadius.circular(60),
                  //                 ),
                  //                 child: Image.asset(
                  //                   "assets/re-kijf.png",
                  //                   width: 114,
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, SectionType type) {
    return GestureDetector(
      onTap: () {
        controller.selectedSection.value = type;
      },
      child: Obx(() {
        final isSelected = controller.selectedSection.value == type;
        return Container(
          decoration: BoxDecoration(
            color: !isSelected ? AppColor.background : AppColor.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildArticleWidget() {
    return Center(child: Text("Article Section"));
  }

  // Widget _buildUpdatesWidget() {
  //   return Container(
  //     height: 400,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       color: Colors.white.withOpacity(0.9),
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: Obx(() {
  //       return Image.network(
  //         controller.bannerImages[controller.currentImageIndex.value],
  //         fit: BoxFit.cover,
  //         width: double.infinity,
  //         errorBuilder: (context, error, stackTrace) {
  //           return Image.asset(
  //             'assets/updateBanner.png',
  //             fit: BoxFit.cover,
  //             width: double.infinity,
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }

  Widget _buildUpdatesWidget() {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => CarouselSlider(
          items: controller.bannerImages.map((url) {
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
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
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
        )),


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

  Widget _buildLiveRateWidget() {
    return Center(child: Text("Live Rate Section"));
  }
}

//GridView.builder(
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2, // Number of columns
//     crossAxisSpacing: 10,
//     mainAxisSpacing: 10,
//   ),
//   itemCount: productList.length,
//   itemBuilder: (context, index) {
//     final product = productList[index];
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: CachedNetworkImage(
//         imageUrl: product.imageUrl ?? '',
//         fit: BoxFit.cover,
//         placeholder: (context, url) => Container(
//           color: Colors.grey[200],
//         ),
//         errorWidget: (context, url, error) => Image.asset(
//           'assets/no_image.png', // Fallback image
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   },
// ),
