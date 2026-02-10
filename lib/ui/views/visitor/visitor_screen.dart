import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dropdown.dart';
import 'package:tjw1/common_widget/common_text_field.dart';
import 'package:tjw1/common_widget/tap_outside_unfocus.dart';
import 'package:tjw1/core/enum/view_state.dart';
import 'package:tjw1/core/model/tjw/designation_response.dart';
import 'package:tjw1/core/model/tjw/visitor_list_response.dart';
import 'package:tjw1/ui/views/add_visitor/add_visitor_screen.dart';
import 'package:tjw1/ui/views/visitor/visitor_controller.dart';
import 'package:tjw1/ui/widgets/file_preview_widget.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/res/colors.dart';
import '../add_visitor/add_visitor_binding.dart';
import '../edit_visitor/edit_visitor_screen.dart';
import '../visitor_detail/visitor_detail_screen.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  final VisitorController controller = Get.put(VisitorController());

  @override
  void initState() {
    controller.loadGstFromStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.visitorListData.isEmpty && !controller.isLoading.value) {
          return AddVisitorScreen(isDashboardForm: true);
        } else {
          return VisitorListScreen(controller: controller);
        }
      }),
    );
  }
}

class VisitorListScreen extends StatelessWidget {
  final VisitorController controller;

  const VisitorListScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Employees",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                height: 40,
                child: CommonButton(
                  text: "+ Add Employee",
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    print("GGGG");
                    // final result = await Get.to(
                    //   () => AddVisitorScreen(),
                    //   arguments: {'isFromEdit': false, 'visitorID': 0},
                    // );

                    final result = await Get.to(
                          () => AddVisitorScreen(),
                      binding: AddVisitorBinding(), // 🔥 THIS IS KEY
                      arguments: {
                        'isFromEdit': false,
                        'visitorID': 0,
                      },
                    );


                    if (result == 'refresh') {
                      controller.fetchVisitorList();
                    }
                  },
                  fillColor: AppColor.secondary,
                  textColor: AppColor.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: controller.visitorListData.length,
              padding: EdgeInsets.only(bottom: 30),
              itemBuilder: (context, index) {
                final data = controller.visitorListData[index];
                return VisitorListItem(
                  data: data,
                  controller: controller,
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget visitorListItem({
    required VisitorListData data,
    required VisitorController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.tertiary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                imageUrl: "${data.visitorPhoto}",
                fit: BoxFit.cover,
                cacheKey: data.visitorID.toString(),
                placeholder:
                    (context, url) => Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                errorWidget:
                    (context, url, error) => Image.asset(
                      'assets/updateBanner.png',
                      fit: BoxFit.cover,
                    ),
              ),
            ),

            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.visitorName!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    data.visitorMobile!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await Get.to(
                              () => EditVisitorScreen(),
                              arguments: {
                                'isFromEdit': true,
                                'visitorID': data.visitorID,
                              },
                            );
                            if (result == 'refresh') {
                              controller.fetchVisitorList();
                            }
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            CommonDialog.showConfirmDialog(
                              title: "Confirm Remove",
                              content: "Are you sure you want to remove ?",
                              confirmText: "Yes",
                              cancelText: "No",
                              onConfirm: () {
                                print("Item removed");
                                Get.back();
                              },
                              leading: Icon(
                                Icons.warning_amber_rounded,
                                size: 48,
                                color: AppColor.primary,
                              ),
                              onCancel: () {
                                Get.back(); // Just close the dialog
                              },
                            );
                          },
                          child: Icon(Icons.delete_forever_sharp),
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
  }


}

class VisitorListItem extends StatefulWidget {
  final VisitorListData data;
  final VisitorController controller;
  const VisitorListItem({super.key, required this.data, required this.controller,});

  @override
  State<VisitorListItem> createState() => _VisitorListItemState();
}

class _VisitorListItemState extends State<VisitorListItem>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // keep widget alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // required for KeepAlive

    return Container(
      decoration: BoxDecoration(
        color: AppColor.tertiary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                imageUrl: "${widget.data.visitorPhoto!}?ts=${DateTime.now().millisecondsSinceEpoch}", //
                fit: BoxFit.cover,
             //   cacheKey: widget.data.visitorID.toString() + (widget.data.visitorPhoto ?? ""),
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                errorWidget: (context, url, error) => Image.asset(
                  'assets/updateBanner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.visitorName!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.data.visitorMobile!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await Get.to(
                                  () => EditVisitorScreen(),
                              arguments: {
                                'isFromEdit': true,
                                'visitorID': widget.data.visitorID,
                              },
                            );
                            if (result == 'refresh') {
                              widget.controller.fetchVisitorList();
                            }

                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            CommonDialog.showConfirmDialog(
                              title: "Confirm Remove",
                              content: "Are you sure you want to remove ?",
                              confirmText: "Yes",
                              cancelText: "No",
                              onConfirm: () {
                                print("Item removed");
                                Get.back();
                              },
                              leading: Icon(
                                Icons.warning_amber_rounded,
                                size: 48,
                                color: AppColor.primary,
                              ),
                              onCancel: () {
                                Get.back(); // Just close the dialog
                              },
                            );
                          },
                          child: Icon(Icons.delete_forever_sharp),
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
  }
}
