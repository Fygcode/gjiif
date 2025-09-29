import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/common_button.dart';
import '../../../core/res/colors.dart';
import 'ebadge_member_controller.dart';

class EbadgeMemberScreen extends StatefulWidget {
  const EbadgeMemberScreen({super.key});

  @override
  State<EbadgeMemberScreen> createState() => _EbadgeMemberScreenState();
}

class _EbadgeMemberScreenState extends State<EbadgeMemberScreen> {
  final EbadgeMemberController controller = Get.put(EbadgeMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("E-Badge", style: TextStyle(color: AppColor.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFFD66A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildVisitorInfo(controller),
                    // Row(
                    //   children: [
                    //     Image.network(
                    //       controller.visitorData.visitorPhotoURL ?? "",
                    //       height: 145,
                    //       width: 145,
                    //     ),
                    //     SizedBox(width: 10),
                    //     controller.visitorData.status == 4 || controller.visitorData.status == 6 ?
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               color: Color(0xffC4FFC6),
                    //               borderRadius: BorderRadius.circular(50),
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 "Approved",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 16,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(height: 8),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               color: Color(0xffFFC000),
                    //               borderRadius: BorderRadius.circular(50),
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 controller.visitorData.barcode ?? "",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 16,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(height: 8),
                    //           CommonButton(
                    //             text: "Download",
                    //             onPressed: () {
                    //               print("CLICKED E-BADGE");
                    //             },
                    //             width: double.infinity,
                    //             padding: EdgeInsets.symmetric(
                    //               vertical: 2,
                    //               horizontal: 0,
                    //             ),
                    //             prefixIcon: Image.asset(
                    //               'assets/downloadIcon.png',
                    //               scale: 2,
                    //               color: AppColor.white,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ) : SizedBox.shrink()
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    Text(
                      controller.visitorData.visitorName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.visitorData.designation ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.visitorData.gstn ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Text(
                          controller.visitorData.phone ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.mail),
                        SizedBox(width: 10),
                        Text(
                          controller.visitorData.emailID ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_sharp),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.visitorData.address ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // keeps it compact
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Call us for immediate assistance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: "Contact Us",
                      onPressed: () async {
                        final String helplineNumber = "+919935043504";

                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: helplineNumber,
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          print("Could not launch dialer");
                        }
                      },
                      fillColor: const Color(0xff9ABFE4),
                      textColor: const Color(0xff183362),
                      prefixIcon: SvgPicture.asset("assets/call.svg"),
                    ),
                  ),
                  const SizedBox(width: 8), // 👈 should be width, not height
                  Expanded(
                    child: CommonButton(
                      text: "Whatsapp",
                      onPressed: () async {
                        final String phoneNumber = "918056119111";

                        final Uri whatsappUri = Uri.parse(
                          "https://wa.me/$phoneNumber",
                        );

                        if (await canLaunchUrl(whatsappUri)) {
                          await launchUrl(
                            whatsappUri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          print("Could not open WhatsApp");
                        }
                      },
                      fillColor: const Color(0xff9AE4A0),
                      textColor: const Color(0xff0D5F14),
                      prefixIcon: SvgPicture.asset("assets/whatsapp.svg"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVisitorInfo(EbadgeMemberController controller) {
    final status = controller.visitorData.status;
    if (status == 3 || status == 6) {
      return Row(
        children: [
          Image.network(
            controller.visitorData.visitorPhotoURL ?? "",
            height: 145,
            width: 145,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffC4FFC6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Approved",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFFC000),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      controller.visitorData.barcode ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CommonButton(
                  text: "Download",
                  onPressed: () {
                    controller.downloadBadge();
                  },
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 0,
                  ),
                  prefixIcon: Image.asset(
                    'assets/downloadIcon.png',
                    scale: 2,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Image.network(
        controller.visitorData.visitorPhotoURL ?? "",
        height: 145,
        width: 145,
      ),
    );
  }

}
