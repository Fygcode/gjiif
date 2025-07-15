import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    child: DropdownMenu(
                      menuHeight: 160,
                      enableSearch: true,
                      textStyle: const TextStyle(fontSize: 16),
                      initialSelection: 'All',
                      controller: controller.filterController,

                      // dropdown text
                      onSelected: (value) {
                        if (value != null) {
                          print("MMMMM $value");
                          controller.filterController.text = value;
                        }
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "All", label: "All"),
                        DropdownMenuEntry(value: "Paid", label: "Paid"),
                        DropdownMenuEntry(
                          value: "Approval Awaiting",
                          label: "Approval Awaiting",
                        ),
                        DropdownMenuEntry(value: "Pending", label: "Pending"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 60),
                  itemCount: controller.selected.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(color: Color(0xffFCF4CB)),
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
                                        "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=612x612&w=0&k=20&c=9zbG2-9fl741fbTWw5fNgcEEe4ll-JegrGlQQ6m54rg=",
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
                                              offset: Offset(
                                                0,
                                                2,
                                              ), // subtle drop shadow
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          // borderRadius: BorderRadius.circular(8),
                                        ),
                                        child:
                                        // inside your build method – wrap with Obx so it rebuilds
                                        Obx(
                                          () => Checkbox(
                                            value: controller.selected[index],
                                            checkColor: AppColor.white,
                                            fillColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >(
                                                  (states) =>
                                                      states.contains(
                                                            WidgetState
                                                                .selected,
                                                          )
                                                          ? AppColor.primary
                                                          : Colors.white,
                                                ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            onChanged: (bool? value) {
                                              controller.selected[index] =
                                                  value ??
                                                  false; // reactive write
                                            },
                                          ),
                                        ),

                                        // Checkbox(
                                        //   value: controller.selected[index],
                                        //   checkColor: AppColor.white,
                                        //   fillColor:
                                        //   WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                        //         if (states.contains(WidgetState.selected,)) {
                                        //           return AppColor.primary;
                                        //         }
                                        //         return Colors.white;
                                        //       }),
                                        //   side: const BorderSide(
                                        //     color: Colors.grey,
                                        //   ),
                                        //   onChanged: (bool? value) {
                                        //     setState(() {
                                        //       controller.selected[index] = value ?? false;
                                        //       print("Checkbox tapped at index: $index",
                                        //       );
                                        //     });
                                        //   },
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Parthasarathy",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "GJ23-TV1234",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "9499956224",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Status : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Paid',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff30910e),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: CommonButton(
                                    text: "Remove",
                                    onPressed: () {
                                      CommonDialog.showConfirmDialog(
                                        title: "Confirm Remove",
                                        content:
                                            "Are you sure you want to remove ?",
                                        confirmText: "Yes",
                                        cancelText: "No",
                                        onConfirm: () {
                                          print("Item removed");
                                          //       Get.back();
                                        },
                                        leading: Icon(
                                          Icons.warning_amber_rounded,
                                          size: 48,
                                          color: AppColor.primary,
                                        ),
                                        onCancel: () {
                                          //        Get.back(); // Just close the dialog
                                        },
                                      );
                                    },
                                    fillColor: AppColor.white,
                                    textColor: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 100,
                                  child: CommonButton(
                                    text: "Edit",
                                    onPressed: () {
                                      Get.to(() => VisitorDetailScreen());
                                    },
                                    fillColor: AppColor.secondary,
                                    textColor: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 15);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: "+ Add Visitor",
                      onPressed: () => Get.to(() => VisitorDetailScreen()),
                      fillColor: AppColor.secondary,
                      textColor: AppColor.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => CommonButton(
                        text: "View Selected (${controller.selectedCount})",
                        onPressed: () => Get.to(() => SummaryScreen()),
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
