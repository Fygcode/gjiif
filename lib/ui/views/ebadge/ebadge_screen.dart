import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tjw1/common_widget/common_dropdown.dart';
import 'package:tjw1/core/model/tjw/registered_badge_response.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import 'ebadge_controller.dart';

class EbadgeScreen extends StatefulWidget {
  String? eventTitle;
  EbadgeScreen({super.key,this.eventTitle});

  @override
  State<EbadgeScreen> createState() => _EbadgeScreenState();
}

class _EbadgeScreenState extends State<EbadgeScreen> {

  final EbadgeController controller = Get.put(EbadgeController());

  @override
  void initState() {
    controller.registeredBadgeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx((){
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return  SafeArea(
          child: TapOutsideUnFocus(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Download E-Badge :",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 10,),
                        // DON'T REMOVE DROPDOWN

                        Expanded (
                          child: CommonDropdown<String>(
                            items: ['GJIIF', 'CJS'],
                            hintText: 'Select Event',
                            selectedItem: controller.eventController.text.isNotEmpty
                                ? controller.eventController.text
                                : null,
                            onChanged: (value) {
                              controller.eventController.text = value ?? '';
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please select an event';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.registeredList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        RegisteredVisitorBadgeList data = controller.registeredList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFCF4CB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.border)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        height: 120,
                                        width: 110,
                                        imageUrl: data.photoURL!,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget:
                                            (context, url, error) => Image.asset(
                                          'assets/updateBanner.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded (
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                    //      SizedBox(height: 4,),
                                          Text(
                                            data.visitorName!,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 4,),
                                          Text(
                                            "ID : ${data.registrationID!}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2,),
                                          Text(
                                            "Mobile : ${data.visitorPhone!}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          SizedBox(height: 6,),

                                          CommonButton(
                                            text: "View Badge",
                                            onPressed: () {
                                              controller.downloadBadge();
                                            },
                                            fillColor: AppColor.secondary,
                                            textColor: AppColor.black,
                                            height: 40,
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(vertical: 2,horizontal: 0),
                                            prefixIcon: Image.asset('assets/downloadIcon.png',scale: 2,),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),

                             


                              ],
                            ),
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                      return Padding(padding: EdgeInsets.all(10));
                    },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      })

    );
  }
}


//  GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: 5,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 15,
//                         crossAxisSpacing: 10,
//                         childAspectRatio: 1.35,
//                       ),
//                       itemBuilder: (BuildContext context, int index) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xffFCF4CB),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: CachedNetworkImage(
//                                         height: 60,
//                                         width: 60,
//                                         imageUrl:
//                                             "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=612x612&w=0&k=20&c=9zbG2-9fl741fbTWw5fNgcEEe4ll-JegrGlQQ6m54rg=",
//                                         fit: BoxFit.cover,
//                                         placeholder:
//                                             (context, url) => const Center(
//                                               child: CircularProgressIndicator(),
//                                             ),
//                                         errorWidget:
//                                             (context, url, error) => Image.asset(
//                                               'assets/updateBanner.png',
//                                               fit: BoxFit.cover,
//                                             ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded (
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Parthasarathy",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           Text(
//                                             "GJ23-TV1234",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Text(
//                                             "9499956224",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Spacer(),
//                                 CommonButton(
//                                   text: "Download",
//                                   onPressed: () {
//                                     controller.downloadBadge();
//                                   },
//                                   fillColor: AppColor.secondary,
//                                   textColor: AppColor.black,
//                                   height: 45,
//                                   padding: EdgeInsets.symmetric(vertical: 2,horizontal: 0),
//                                   prefixIcon: Image.asset('assets/downloadIcon.png',scale: 2,),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),