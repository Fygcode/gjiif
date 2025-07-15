import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tjw1/common_widget/common_dialog.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/ui/views/selectPrimaryNo/select_primary_controller.dart';

class SelectPrimaryScreen extends StatefulWidget {
  List<VisitorPhone>? data;

  SelectPrimaryScreen(this.data, {super.key});

  @override
  State<SelectPrimaryScreen> createState() => _SelectPrimaryScreenState();
}

class _SelectPrimaryScreenState extends State<SelectPrimaryScreen> {
  final SelectPrimaryController controller = Get.put(SelectPrimaryController());

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: AppColor.background,
    //   body: SafeArea (
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text("Select Primary Number",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
    //           SizedBox(height: 20,),
    //           Expanded (
    //             child: ListView.separated(
    //               itemCount: widget.data!.length,
    //               itemBuilder: (context, index) {
    //                 VisitorData data = widget.data![index];
    //                 return InkWell (
    //                   onTap: (){
    //                     print(index);
    //
    //                   },
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text("Visitor ID : ${data.visitorID}", style: TextStyle(fontSize: 16)),
    //                           SizedBox(height: 6,),
    //                           Text("Phone Number : ${data.mobileNumber}",style: TextStyle(fontSize: 16),),
    //                         ],
    //                       ),
    //                       Icon(Icons.arrow_forward_ios_rounded,size: 20,),
    //                     ],
    //                   ),
    //                 );
    //               }, separatorBuilder: (BuildContext context, int index) {
    //               return Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 8),
    //                 child: Divider(color: AppColor.border,),
    //               );
    //             },
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    //   ),

    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.background,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Primary Number",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.data!.length,
                        itemBuilder: (context, index) {
                          VisitorPhone data = widget.data![index];
                          return InkWell(
                            onTap: () {
                              print(index);
                              CommonDialog.showConfirmDialog(
                                title: "Select Primary Number",
                                content:
                                    "Do you want to set this ${data.mobileNumber} number as your primary contact?",
                                confirmText: "Yes",
                                cancelText: "No",
                                leading: Icon(
                                  Icons.account_box_rounded,
                                  size: 48,
                                  color: AppColor.primary,
                                ),
                                onConfirm: () {
                                  controller.setPrimaryNumber(data);
                                },
                                onCancel: () {
                                  // Get.back(); // Optional: Close dialog
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Visitor ID : ${data.visitorID}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Phone Number : ${data.mobileNumber}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(color: AppColor.border),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              // Optional: darken background
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
