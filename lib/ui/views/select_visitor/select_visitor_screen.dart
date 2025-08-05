import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/registered_visitor_list.dart';
import 'package:tjw1/ui/views/add_visitor/add_visitor_screen.dart';
import 'package:tjw1/ui/views/edit_visitor/edit_visitor_screen.dart';
import 'package:tjw1/ui/views/select_visitor/select_visitor_controller.dart';
import 'package:tjw1/ui/views/summary/summary_screen.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/res/colors.dart';
import '../visitor_detail/visitor_detail_screen.dart';

class SelectVisitorScreen extends StatefulWidget {
  const SelectVisitorScreen({super.key});

  @override
  State<SelectVisitorScreen> createState() => _SelectVisitorScreenState();
}

class _SelectVisitorScreenState extends State<SelectVisitorScreen> {
  final SelectVisitorController controller = Get.put(SelectVisitorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7DF),
      extendBodyBehindAppBar: false,
      extendBody: true,
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
        title: Image.asset('assets/GJIIF_Logo.png', height: 35),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Employee to Register",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Filter : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 50,
                        child: DropdownMenu<StatusList>(
                          menuHeight: 250,
                          controller: controller.filterController,
                          initialSelection: controller.statusList
                              .firstWhereOrNull((e) => e.status == 'All'),
                          textStyle: const TextStyle(fontSize: 14, height: 1.2),
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                          onSelected: (value) {
                            if (value != null) {
                              controller.filterController.text = value.status!;
                              print("DD == ${controller.filterController.text}");
                              print("statusID == ${value.statusID}");
                              controller.dropdownStatusId = value.statusID ?? -1;
                              controller.filterVisitorListByStatus(
                                value.statusID.toString(),
                              );
                            }
                          },
                          dropdownMenuEntries:
                              controller.statusList
                                  .map(
                                    (status) => DropdownMenuEntry<StatusList>(
                                      value: status,
                                      label: status.status ?? '',
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    padding: EdgeInsets.only(bottom: 60),
                    itemCount: controller.visitorList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final visitor = controller.visitorList[index];

                      return Container(
                        decoration: BoxDecoration(
                          color:
                              index % 2 == 0
                                  ? Color(0xffFCF4CB)
                                  : Color(0xffF0F0F0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      height: 100,
                                      width: 100,
                                      imageUrl:
                                          visitor.visitorPhotoURL ??
                                          "https://via.placeholder.com/100",
                                      // fallback image
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColor.primary,
                                                  AppColor.textPrimary,
                                                ],
                                                // or your custom gradient colors
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    8,
                                                  ), // optional rounded corners
                                            ),
                                            child: Image.asset(
                                              'assets/GJIIF_Logo.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      left: -10,
                                      child: Transform.scale(
                                        scale: 1.1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Obx(
                                            () => Checkbox(
                                              value: controller.selected[index],
                                              checkColor: AppColor.white,
                                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                                    (states) => states.contains(
                                                              WidgetState
                                                                  .selected,
                                                            )
                                                            ? AppColor.primary
                                                            : Colors.white,
                                                  ),
                                              side: const BorderSide(
                                                color: Colors.black,
                                              ),

                                              onChanged: (bool? value) async {
                                                controller.selected[index] = value ?? false;
                                                final visitorID = visitor.visitorID.toString();

                                                if (controller.selected[index]) {
                                                  // Add to selected list
                                                  if (!controller.selectedVisitorIDs.contains(visitorID)) {
                                                    controller.selectedVisitorIDs.add(visitorID);}
                                                } else {
                                                  // Remove if unchecked
                                                  controller.selectedVisitorIDs.remove(visitorID);
                                                }

                                                print("VISITOR ID: $visitorID");
                                                print("SELECTED VISITOR IDs: ${controller.selectedVisitorIDs}",);

                                                final isIncomplete =
                                                    await controller
                                                        .isVisitorRegisterWithAllDetail(
                                                          visitor.visitorID
                                                              .toString(),
                                                        );
                                                if (isIncomplete) {
                                                  controller.handleIncompleteVisitor(
                                                    visitorID: visitor.visitorID!,
                                                    index: index,
                                                    context: context,
                                                  );

                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      visitor.visitorName ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      visitor.visitorPhone ?? 'No Mobile',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Status : ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          TextSpan(
                                            text: visitor.status ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: controller
                                                  .getStatusColorByID(
                                                    visitor.statusID!,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (BuildContext context, int index) =>
                            SizedBox(height: 15),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: "+ Add Visitor",

                      onPressed: () {
                        Get.to(
                          () => AddVisitorScreen(),
                          arguments: {'isFromEdit': false, 'visitorID': 0},
                        )?.then((_) {
                          print("BACKED");
                          controller.fetchRegisteredVisitorList();
                        });
                      },

                      fillColor: AppColor.secondary,
                      textColor: AppColor.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => CommonButton(
                        text: "Proceed (${controller.selectedCount})",
                        onPressed: () => Get.to(
                              () => SummaryScreen(),
                          arguments: {
                            'visitorList': controller.selectedVisitorIDs.toList(),
                            'eventId': controller.eventId.value,
                          },
                        ),
                        isDisabled: controller.selectedCount == 0,
                      ),
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
}
