// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:tjw1/common_widget/common_dropdown.dart';
// import 'package:tjw1/core/model/tjw/registered_badge_response.dart';
//
// import '../../../common_widget/common_button.dart';
// import '../../../common_widget/tap_outside_unfocus.dart';
// import '../../../core/res/colors.dart';
// import 'ebadge_controller.dart';
//
// class EbadgeScreen extends StatefulWidget {
//   String? eventTitle;
//   EbadgeScreen({super.key,this.eventTitle});
//
//   @override
//   State<EbadgeScreen> createState() => _EbadgeScreenState();
// }
//
// class _EbadgeScreenState extends State<EbadgeScreen> {
//
//   final EbadgeController controller = Get.put(EbadgeController());
//
//   @override
//   void initState() {
//     controller.registeredBadgeList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: AppColor.background,
//       body: Obx((){
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if(!controller.registeredList.isEmpty == false){
//           return Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset("assets/NoVisitorFound.svg"),
//                 SizedBox(height: 20,),
//                 Text("There is no data to show you right now",style: TextStyle(fontSize: 20,color: Color(0xff4A4A4A)),),
//               ],
//             ),
//           );
//         }
//         return  SafeArea(
//           child: TapOutsideUnFocus(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Text(
//                           "Download E-Badge :",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(width: 10,),
//                         // DON'T REMOVE DROPDOWN
//
//                         Expanded (
//                           child: CommonDropdown<String>(
//                             items: ['GJIIF', 'CJS'],
//                             hintText: 'Select Event',
//                             selectedItem: controller.eventController.text.isNotEmpty
//                                 ? controller.eventController.text
//                                 : null,
//                             onChanged: (value) {
//                               controller.eventController.text = value ?? '';
//                             },
//                             validator: (val) {
//                               if (val == null || val.isEmpty) {
//                                 return 'Please select an event';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: controller.registeredList.length,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         RegisteredVisitorBadgeList data = controller.registeredList[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xffFCF4CB),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: AppColor.border)
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: CachedNetworkImage(
//                                         height: 120,
//                                         width: 110,
//                                         imageUrl: data.photoURL!,
//                                         fit: BoxFit.cover,
//                                         placeholder:
//                                             (context, url) => const Center(
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                         errorWidget:
//                                             (context, url, error) => Image.asset(
//                                           'assets/updateBanner.png',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 14),
//                                     Expanded (
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                                         children: [
//                                     //      SizedBox(height: 4,),
//                                           Text(
//                                             data.visitorName!,
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w600,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           SizedBox(height: 4,),
//                                           Text(
//                                             "ID : ${data.registrationID!}",
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           SizedBox(height: 2,),
//                                           Text(
//                                             "Mobile : ${data.visitorPhone!}",
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//
//                                           SizedBox(height: 6,),
//
//                                           CommonButton(
//                                             text: "View Badge",
//                                             onPressed: () {
//                                               print("CLICKED E-BADGE");
//                                               controller.viewBadge(context,data.registrationID);
//                                             },
//                                             fillColor: AppColor.secondary,
//                                             textColor: AppColor.black,
//                                             height: 40,
//                                             width: double.infinity,
//                                             padding: EdgeInsets.symmetric(vertical: 2,horizontal: 0),
//                                             prefixIcon: Image.asset('assets/downloadIcon.png',scale: 2,),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//
//
//
//
//                               ],
//                             ),
//                           ),
//                         );
//                       }, separatorBuilder: (BuildContext context, int index) {
//                       return Padding(padding: EdgeInsets.all(10));
//                     },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       })
//
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/dropdown_api.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/model/tjw/registered_badge_response.dart';
import '../../../core/res/colors.dart';
import 'ebadge_controller.dart';

class EbadgeScreen extends StatefulWidget {
  final String? eventTitle;

  const EbadgeScreen({super.key, this.eventTitle});

  @override
  State<EbadgeScreen> createState() => _EbadgeScreenState();
}

class _EbadgeScreenState extends State<EbadgeScreen> {
  final EbadgeController controller = Get.put(EbadgeController());

  // @override
  // void initState() {
  //   super.initState();
  //   controller.dropdownListApi();
  //   controller.registeredBadgeList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        return SafeArea(
          child: TapOutsideUnFocus(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                   // _buildBadgeList(),

                  if (controller.isLoading.value)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.hasLoadedOnce.value &&
                      controller.registeredList.isEmpty)
                    _buildEmptyState()
                  else
                    _buildBadgeList(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Header Section with Dropdown
  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          "Download E-Badge:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CommonDropdown<String>(
            items:
                controller.dropdownList.map((e) => e.eventShortName ?? '').toList(),
            hintText: 'Select Event',
            selectedItem:
                controller.eventController.text.isNotEmpty
                    ? controller.eventController.text
                    : null,
            onChanged: (value) {
              controller.eventController.text = value ?? '';

              // find matching event in the dropdownList
              final selectedEvent = controller.dropdownList.firstWhere(
                (e) => e.eventShortName == value,
                orElse: () => DropDownData(), // fallback if not found
              );

              controller.selectedEventId = selectedEvent.eventID.toString();
              controller.registeredBadgeList();

              print("✅ Selected Event ID: ${selectedEvent.eventID}");
            },

            validator:
                (val) =>
                    val == null || val.isEmpty
                        ? 'Please select an event'
                        : null,
          ),
        ),
      ],
    );
  }

  /// Empty State View
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/NoVisitorFound.svg", height: 200),
          const SizedBox(height: 20),
          const Text(
            "There is no data to show you right now",
            style: TextStyle(fontSize: 18, color: Color(0xff4A4A4A)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Badge List
  Widget _buildBadgeList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.registeredList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final data = controller.registeredList[index];
        return _buildBadgeCard(data);
      },
    );
  }

  /// Individual Badge Card
  Widget _buildBadgeCard(RegisteredVisitorBadgeList data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFCF4CB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.border),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBadgeImage(data.photoURL),
          const SizedBox(width: 14),
          Expanded(child: _buildBadgeInfo(data)),
        ],
      ),
    );
  }

  /// Image with Placeholder and Error Handling
  Widget _buildBadgeImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        height: 120,
        width: 110,
        imageUrl: imageUrl ?? '',
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const SizedBox(
              height: 40,
              width: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        errorWidget:
            (context, url, error) =>
                Image.asset('assets/updateBanner.png', fit: BoxFit.cover),
      ),
    );
  }

  /// Text and Button Section
  Widget _buildBadgeInfo(RegisteredVisitorBadgeList data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.visitorName ?? 'N/A',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "ID: ${data.registrationID ?? '-'}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          "Mobile: ${data.visitorPhone ?? '-'}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        CommonButton(
          text: "View Badge",
          onPressed: () => controller.viewBadge(context, data.registrationID),
          fillColor: AppColor.secondary,
          textColor: AppColor.black,
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2),
          prefixIcon: Image.asset('assets/downloadIcon.png', scale: 2),
        ),
      ],
    );
  }
}
