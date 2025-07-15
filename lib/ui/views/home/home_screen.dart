import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => EventDetailScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.border.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  padding: const EdgeInsets.all(10),
                                  // Add padding here
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    "assets/event_gjiif.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Gem & Jewellery India International Fair.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 6),

                                      Row(
                                        children: [
                                          Icon(Icons.date_range, size: 20),
                                          SizedBox(width: 4),
                                          Text("Sep 12th - 14th 2025"),
                                        ],
                                      ),

                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text("Chennai Trade Centre"),
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
                    ),

                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                AppColor.gradient1,
                                AppColor.gradient2,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Today’s South India Rates",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff581728),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/calender.svg",
                                    color: AppColor.textPrimary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Mon, Jul 14, 2025",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: VerticalDivider(color: AppColor.textPrimary),
                                  ),
                                  SvgPicture.asset("assets/clock.svg"),
                                  SizedBox(width: 6),
                                  Text.rich(
                                    TextSpan(
                                      text: "6:30 ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "AM",
                                          style: TextStyle(
                                            fontSize: 14, // Smaller font size for AM
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8,top: 10,right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.gradientGold1,
                                          AppColor.gradientGold2,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 6),
                                          child: Row(
                                            children: [
                                              Text(
                                                "22kt Gold",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff151515),
                                                ),
                                              ),
                                              SizedBox(width: 9),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.textPrimary,
                                                  borderRadius: BorderRadius.circular(
                                                    100,
                                                  ),
                                                ),
                                                child: Text(
                                                  "1 Gms",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,bottom: 10,top: 5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/priceHigh.svg"),
                                              SizedBox(width: 4),
                                              Text(
                                                "₹ 9,155",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Text("Excl. 3% GST",style: TextStyle(fontSize: 14,color: AppColor.black,fontWeight: FontWeight.w500),)
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
                                      "assets/gold.svg",
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8,top: 10,right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.gradientGold1,
                                          AppColor.gradientGold2,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 6),
                                          child: Row(
                                            children: [
                                              Text(
                                                "18kt Gold ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff151515),
                                                ),
                                                overflow: TextOverflow.ellipsis, // truncate if too long
                                                softWrap: false,
                                              ),
                                              SizedBox(width: 9),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.textPrimary,
                                                  borderRadius: BorderRadius.circular(
                                                    100,
                                                  ),
                                                ),
                                                child: Text(
                                                  "1 Gms",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,bottom: 10,top: 5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/priceHigh.svg"),
                                              SizedBox(width: 4),
                                              Text(
                                                "₹ 7,540",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Text("Excl. 3% GST",style: TextStyle(fontSize: 14,color: AppColor.black,fontWeight: FontWeight.w500),)
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
                                      "assets/gold.svg",
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8,top: 10,right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.gradient3,
                                          AppColor.gradient4,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 6),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Silver",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff151515),
                                                ),
                                              ),
                                              SizedBox(width: 9),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.textPrimary,
                                                  borderRadius: BorderRadius.circular(
                                                    100,
                                                  ),
                                                ),
                                                child: Text(
                                                  "1 Gms",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,bottom: 10,top: 5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/priceHigh.svg"),
                                              SizedBox(width: 4),
                                              Text(
                                                "₹ 127.00",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Text("Excl. 3% GST",style: TextStyle(fontSize: 14,color: AppColor.black,fontWeight: FontWeight.w500),)
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
                                      "assets/silver.svg",
                                      height: 80,
                                      //     color: Color(0xff757574),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    //////////////////////////////

                    SizedBox(height: 50),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 50,
                    //     horizontal: 25,
                    //   ),
                    //   child: Center(
                    //     child: Obx(
                    //       () => Text(
                    //         controller.quotes[controller
                    //             .currentQuoteIndex
                    //             .value],
                    //         key: ValueKey(controller.currentQuoteIndex.value),
                    //         style: const TextStyle(
                    //           fontSize: 22,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.grey,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
        // Obx(
        //   () => CarouselSlider(
        //     items:
        //         controller.bannerImages.map((url) {
        //           return Container(
        //             width: double.infinity,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(12),
        //               color: Colors.white.withOpacity(0.9),
        //             ),
        //             clipBehavior: Clip.antiAlias,
        //             child: CachedNetworkImage(
        //               imageUrl: url,
        //               fit: BoxFit.cover,
        //               width: double.infinity,
        //               placeholder:
        //                   (context, url) =>
        //                       const Center(child: CircularProgressIndicator()),
        //               errorWidget:
        //                   (context, url, error) => Image.asset(
        //                     'assets/updateBanner.png',
        //                     fit: BoxFit.cover,
        //                   ),
        //             ),
        //           );
        //         }).toList(),
        //     options: CarouselOptions(
        //       height: 400,
        //       autoPlay: true,
        //       enlargeCenterPage: true,
        //       viewportFraction: 1.0,
        //       onPageChanged: (index, reason) {
        //         controller.currentImageIndex.value = index;
        //       },
        //     ),
        //   ),
        // ),
        Obx(
          () => CarouselSlider(
            items:
                controller.bannerImages.map((path) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      path,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
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
