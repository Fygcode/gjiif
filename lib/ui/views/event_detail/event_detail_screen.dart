import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../common_widget/common_button.dart';
import '../../../core/res/colors.dart';
import '../visitor_detail/visitor_detail_screen.dart';
import 'event_detail_controller.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventDetailController controller = Get.put(EventDetailController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.background,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title:  Image.asset('assets/GJIIF_Logo.png', height: 35),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: size.width, // Square layout
                color: Colors.black,
                child: Image.asset(
                  'assets/EventScreen_GJIIF.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(34),
                    topRight: Radius.circular(34),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 20,
                      bottom: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Gems and Jewelry India International Fair",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            "Chennai trade centre Nandambakkam, Chennai",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Lottie.asset(
                              'assets/live_pulse.json',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "12th  - 14th  Sep, 2025",
                              style: TextStyle(
                                color: AppColor.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₹500 ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "till 30th Nov",
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "₹ 1,000 - 1st to 12th Dec. 2025",
                          style: TextStyle(
                            color: AppColor.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "₹ 1,500 - 12th to 18th Dec. 2025",
                          style: TextStyle(
                            color: AppColor.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Discover Brilliance at the 2025 Jewel Expo!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Step into a world of elegance and craftsmanship at the Jewel Expo 2025, where the finest jewelry designers, brands, and artisans from around the globe gather under one roof. Explore a curated showcase of timeless pieces, cutting-edge trends, and one-of-a-kind creations that redefine luxury.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6, // for better line height
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea (
          bottom: true,
          child: Container(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 10),
            color: AppColor.background,
            child: CommonButton(
              text: "Register Now",
              onPressed: () {
                Get.to(() => VisitorDetailScreen());
              },
            ),
          ),
        ),
      ),
    );
  }
}
