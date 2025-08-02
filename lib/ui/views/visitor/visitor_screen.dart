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
        if (controller.visitorListData.isEmpty) {
          return VisitorFormScreen(controller: controller);
        } else {
          return VisitorListScreen(controller: controller);
        }
      }),
    );
  }
}

class VisitorFormScreen extends StatelessWidget {
  final VisitorController controller;

  const VisitorFormScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TapOutsideUnFocus(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Visitor Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Expanded(
                child: visitorFormFields(
                  controller: controller,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  visitorFormFields({
    required VisitorController controller,
    required BuildContext context,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonDropdown<String>(
            items:
                Gender.values
                    .map((e) => e.name[0].toUpperCase() + e.name.substring(1))
                    .toList(),
            hintText: 'Gender',
            //  isRequired: true,
            selectedItem:
                controller.genderController.text.isNotEmpty
                    ? controller.genderController.text.capitalizeFirst
                    : null,
            onChanged: (value) {
              Gender? selectedStatus = Gender.values.firstWhere(
                (e) => e.name.toLowerCase() == value?.toLowerCase(),
                orElse: () => Gender.male,
              );
              controller.genderController.text = selectedStatus.name;
              print("Selected: $selectedStatus");
              print("Selected: ${controller.genderController.text}");
            },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please select gender';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          // Company Type
          Text(
            "Name",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonTextField(
            controller: controller.nameController,
            focusNode: controller.nameFocusNode,
            hintText: 'Enter Name*',
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter name ';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          // Company Name
          Text(
            "Designation",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Obx(
            () => CommonDropdown<DesignationData>(
              items: controller.designationList.toList(),
              hintText: 'Enter State*',
              selectedItem: controller.designationList.firstWhere(
                (e) =>
                    e.designationID ==
                    int.tryParse(controller.designationID.value ?? '0'),
                orElse:
                    () => DesignationData(designationID: 0, designation: ''),
              ),
              itemAsString: (state) => state.designation ?? '',
              compareFn: (a, b) => a.designationID == b.designationID,
              onChanged: (value) {
                if (value != null) {
                  controller.designationController.text =
                      value.designation ?? '';
                  controller.designationID.value =
                      value.designationID.toString() ?? "";
                }
              },
              validator: (val) {
                if (val == null || val.designation?.isEmpty == true) {
                  return 'Please designation state';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),

          Text(
            "Phone Number",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonTextField.phone(
            controller: controller.phoneNumberController,
            focusNode: controller.phoneNumberFocusNode,
            hintText: 'Phone Number *',
            enabled: false,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter phone number';
              }
              RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
              if (!phoneRegExp.hasMatch(val)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          // City
          Text(
            "E-mail ID",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonTextField.email(
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            hintText: 'Enter Email*',
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter email';
              }

              final emailRegex = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
                r"@"
                r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
                r"(?:\.[a-zA-Z]{2,})+$",
              );

              if (!emailRegex.hasMatch(val.trim())) {
                return 'Please enter a valid email address';
              }

              return null;
            },
          ),

          SizedBox(height: 10),

          // State
          Text(
            "ID type ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonDropdown<String>(
            items:
                IDType.values
                    .map((e) => e.name[0].toUpperCase() + e.name.substring(1))
                    .toList(),
            hintText: 'ID-Type',
            //  isRequired: true,
            selectedItem:
                controller.idTypeController.text.isNotEmpty
                    ? controller.idTypeController.text.capitalizeFirst
                    : null,
            onChanged: (value) {
              IDType? selectedStatus = IDType.values.firstWhere(
                (e) => e.name.toLowerCase() == value?.toLowerCase(),
                orElse: () => IDType.aadhaar,
              );
              controller.idTypeController.text = selectedStatus.name;
              print("Selected: $selectedStatus");
              print("Selected: ${controller.idTypeController.text}");
            },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please select ID-Type';
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          // Pincode
          Text(
            "ID number",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          CommonTextField(
            controller: controller.idNumberController,
            focusNode: controller.idNumberFocusNode,
            hintText: 'Enter ID number*',
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter ID number';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          Text(
            "Business Card",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              controller.pickFile('businessCard');
            },
            child: DottedBorder(
              options: RectDottedBorderOptions(
                strokeWidth: 1,
                color: AppColor.grey.withOpacity(0.6),
                dashPattern: [3, 6],
                strokeCap: StrokeCap.square,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColor.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/uploadIcon.png", scale: 3),
                    SizedBox(width: 20),
                    Text(
                      "Upload Business Card",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2),

          // Obx(() {
          //   final filePath = controller.businessFilePath;
          //   final fileName =
          //       controller.businessFileName.value;
          //   //
          //   if (filePath == null || fileName.isEmpty) {
          //     return const SizedBox.shrink();
          //   }
          //   return InkWell(
          //     onTap: () {
          //       if (controller.isLoading.value) {
          //         print("It's loading ");
          //         return;
          //       }
          //       CommonDialog.showCustomDialog(
          //         content: SizedBox(
          //           width:
          //           MediaQuery.of(context).size.width * 0.9,
          //           height: MediaQuery.of(context).size.height * 0.6,
          //           child: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child:
          //             filePath.toLowerCase().endsWith(
          //               '.pdf',
          //             )
          //                 ? SfPdfViewer.file(
          //               File(filePath),
          //               canShowScrollHead: true,
          //               canShowScrollStatus: true,
          //               enableDoubleTapZooming: true,
          //               initialZoomLevel: 1,
          //             )
          //                 : Image.file(
          //               File(filePath),
          //               fit: BoxFit.contain,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               fileName,
          //               style: const TextStyle(
          //                 fontSize: 14,
          //                 decoration:
          //                 TextDecoration.underline,
          //                 color: Colors.blue,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Image.asset(
          //             'assets/tick.png',
          //             scale: 2,
          //             color: Colors.green,
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
          // Obx(() {
          //   final error = controller.businessError.value;
          //   return error.isNotEmpty
          //       ? Padding(
          //     padding: const EdgeInsets.only(top: 4),
          //     child: Text(
          //       error,
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontSize: 12,
          //       ),
          //     ),
          //   )
          //       : SizedBox.shrink();
          // }),
          FilePreviewWidget(
            filePath: controller.businessFilePath,
            fileName: controller.businessFileName,
            errorText: controller.businessError,
            isLoading: controller.isLoading,
          ),

          SizedBox(height: 10),

          Text(
            "Passport Photo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              controller.pickFile('photo');
            },
            child: DottedBorder(
              options: RectDottedBorderOptions(
                strokeWidth: 1,
                color: AppColor.grey.withOpacity(0.6),
                dashPattern: [3, 6],
                strokeCap: StrokeCap.square,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColor.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/uploadIcon.png", scale: 3),
                    SizedBox(width: 20),
                    Text(
                      "Upload Passport Photo",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2),

          // Obx(() {
          //   final filePath = controller.passportPhotoPath;
          //   final fileName =
          //       controller.passportPhotoName.value;
          //   //
          //   if (filePath == null || fileName.isEmpty) {
          //     return const SizedBox.shrink();
          //   }
          //   return InkWell(
          //     onTap: () {
          //       if (controller.isLoading.value) {
          //         print("It's loading ");
          //         return;
          //       }
          //       CommonDialog.showCustomDialog(
          //         content: SizedBox(
          //           width:
          //           MediaQuery.of(context).size.width *
          //               0.9,
          //           height:
          //           MediaQuery.of(context).size.height *
          //               0.6,
          //           child: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child:
          //             filePath.toLowerCase().endsWith(
          //               '.pdf',
          //             )
          //                 ? SfPdfViewer.file(
          //               File(filePath),
          //               canShowScrollHead: true,
          //               canShowScrollStatus: true,
          //               enableDoubleTapZooming: true,
          //               initialZoomLevel: 1,
          //             )
          //                 : Image.file(
          //               File(filePath),
          //               fit: BoxFit.contain,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               fileName,
          //               style: const TextStyle(
          //                 fontSize: 14,
          //                 decoration:
          //                 TextDecoration.underline,
          //                 color: Colors.blue,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Image.asset(
          //             'assets/tick.png',
          //             scale: 2,
          //             color: Colors.green,
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
          //
          // Obx(() {
          //   final error = controller.passportPhotoError.value;
          //   return error.isNotEmpty
          //       ? Padding(
          //     padding: const EdgeInsets.only(top: 4),
          //     child: Text(
          //       error,
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontSize: 12,
          //       ),
          //     ),
          //   )
          //       : SizedBox.shrink();
          // }),
          FilePreviewWidget(
            filePath: controller.passportPhotoPath,
            fileName: controller.passportPhotoName,
            errorText: controller.passportPhotoError,
            isLoading: controller.isLoading,
          ),

          SizedBox(height: 10),

          Text(
            "ID Proof",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              controller.pickFile('idProof');
            },
            child: DottedBorder(
              options: RectDottedBorderOptions(
                strokeWidth: 1,
                color: AppColor.grey.withOpacity(0.6),
                dashPattern: [3, 6],
                strokeCap: StrokeCap.square,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColor.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/uploadIcon.png", scale: 3),
                    SizedBox(width: 20),
                    Text(
                      "Upload ID-Proof",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2),

          // Obx(() {
          //   final filePath = controller.idProofPath.value;
          //   final fileName = controller.idProofName.value;
          //   //
          //   if (filePath == null || fileName.isEmpty) {
          //     return const SizedBox.shrink();
          //   }
          //   return InkWell(
          //     onTap: () {
          //       if (controller.isLoading.value) {
          //         print("It's loading ");
          //         return;
          //       }
          //       CommonDialog.showCustomDialog(
          //         content: SizedBox(
          //           width:
          //           MediaQuery.of(context).size.width *
          //               0.9,
          //           height:
          //           MediaQuery.of(context).size.height *
          //               0.6,
          //           child: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child:
          //             filePath.toLowerCase().endsWith(
          //               '.pdf',
          //             )
          //                 ? SfPdfViewer.file(
          //               File(filePath),
          //               canShowScrollHead: true,
          //               canShowScrollStatus: true,
          //               enableDoubleTapZooming: true,
          //               initialZoomLevel: 1,
          //             )
          //                 : Image.file(
          //               File(filePath),
          //               fit: BoxFit.contain,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               fileName,
          //               style: const TextStyle(
          //                 fontSize: 14,
          //                 decoration:
          //                 TextDecoration.underline,
          //                 color: Colors.blue,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Image.asset(
          //             'assets/tick.png',
          //             scale: 2,
          //             color: Colors.green,
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
          //
          // Obx(() {
          //   final error = controller.idProofError.value;
          //   return error.isNotEmpty
          //       ? Padding(
          //     padding: const EdgeInsets.only(top: 4),
          //     child: Text(
          //       error,
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontSize: 12,
          //       ),
          //     ),
          //   )
          //       : SizedBox.shrink();
          // }),
          FilePreviewWidget(
            filePath: controller.idProofPath,
            fileName: controller.idProofName,
            errorText: controller.idProofError,
            isLoading: controller.isLoading,
          ),

          SizedBox(height: 20),

          Obx(() {
            return CommonButton(
              text: "Save",
              isLoading: controller.isLoading.value,
              onPressed: () {
                controller.saveVisitor();
              },
            );
          }),
          SizedBox(height: 60),
        ],
      ),
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
                width: 120,
                height: 40,
                child: CommonButton(
                  text: "+ Add Visitor",
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final result = await Get.to(
                      () => AddVisitorScreen(),
                      arguments: {'isFromEdit': false, 'visitorID': 0},
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
                return visitorListItem(data: data, controller: controller);
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
                imageUrl: (data.visitorPhoto ?? "").startsWith("http")
                    ? "${data.visitorPhoto}?ts=${DateTime.now().millisecondsSinceEpoch}"
                    : (data.visitorPhoto ?? ""),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Image.asset(
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
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 100,
                  child: CommonButton(
                    text: "Remove",
                    onPressed: () {
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
                    fillColor: AppColor.white,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 100,
                  child: CommonButton(
                    text: "Edit",
                    onPressed: () async {
                      final result = await Get.to(
                            () => EditVisitorScreen(),
                        arguments: {'isFromEdit': true, 'visitorID': data.visitorID},
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
          ],
        ),
      ),
    );
  }
}

// if empty means only display this
// return TapOutsideUnFocus(
//   child: Padding(
//     padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
//     child: Form(
//       key: controller.formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Add Visitor Details",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 20),
//
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Gender",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonDropdown<String>(
//                     items:
//                         Gender.values
//                             .map(
//                               (e) =>
//                                   e.name[0].toUpperCase() +
//                                   e.name.substring(1),
//                             )
//                             .toList(),
//                     hintText: 'Gender',
//                     //  isRequired: true,
//                     selectedItem:
//                         controller.genderController.text.isNotEmpty
//                             ? controller
//                                 .genderController
//                                 .text
//                                 .capitalizeFirst
//                             : null,
//                     onChanged: (value) {
//                       Gender? selectedStatus = Gender.values
//                           .firstWhere(
//                             (e) =>
//                                 e.name.toLowerCase() ==
//                                 value?.toLowerCase(),
//                             orElse: () => Gender.male,
//                           );
//                       controller.genderController.text =
//                           selectedStatus.name;
//                       print("Selected: $selectedStatus");
//                       print(
//                         "Selected: ${controller.genderController.text}",
//                       );
//                     },
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please select gender';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),
//
//                   // Company Type
//                   Text(
//                     "Name",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonTextField(
//                     controller: controller.nameController,
//                     focusNode: controller.nameFocusNode,
//                     hintText: 'Enter Name*',
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please enter name ';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),
//
//                   // Company Name
//                   Text(
//                     "Designation",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Obx(() => CommonDropdown<DesignationData>(
//                     items: controller.designationList.toList(),
//                     hintText: 'Enter State*',
//                     selectedItem: controller.designationList.firstWhere(
//                           (e) => e.designationID == int.tryParse(controller.designationID.value ?? '0'),
//                       orElse:
//                           () => DesignationData(designationID: 0, designation: ''),
//                     ),
//                     itemAsString: (state) => state.designation ?? '',
//                     compareFn: (a, b) => a.designationID == b.designationID,
//                     onChanged: (value) {
//                       if (value != null) {
//                         controller.designationController.text = value.designation ?? '';
//                         controller.designationID.value = value.designationID.toString() ?? "";
//                       }
//                     },
//                     validator: (val) {
//                       if (val == null || val.designation?.isEmpty == true) {
//                         return 'Please designation state';
//                       }
//                       return null;
//                     },
//                   )),
//                   SizedBox(height: 10),
//
//                   Text(
//                     "Phone Number",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonTextField.phone(
//                     controller: controller.phoneNumberController,
//                     focusNode: controller.phoneNumberFocusNode,
//                     hintText: 'Phone Number *',
//                     enabled: false,
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please enter phone number';
//                       }
//                       RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
//                       if (!phoneRegExp.hasMatch(val)) {
//                         return 'Please enter a valid phone number';
//                       }
//                       return null;
//                     },
//                   ),
//
//                   SizedBox(height: 10),
//
//                   // City
//                   Text(
//                     "E-mail ID",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonTextField.email(
//                     controller: controller.emailController,
//                     focusNode: controller.emailFocusNode,
//                     hintText: 'Enter Email*',
//                     validator: (val) {
//                       if (val == null || val.trim().isEmpty) {
//                         return 'Please enter email';
//                       }
//
//                       final emailRegex = RegExp(
//                         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
//                         r"@"
//                         r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
//                         r"(?:\.[a-zA-Z]{2,})+$",
//                       );
//
//                       if (!emailRegex.hasMatch(val.trim())) {
//                         return 'Please enter a valid email address';
//                       }
//
//                       return null;
//                     },
//                   ),
//
//                   SizedBox(height: 10),
//
//                   // State
//                   Text(
//                     "ID type ",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonDropdown<String>(
//                     items:
//                         IDType.values
//                             .map(
//                               (e) =>
//                                   e.name[0].toUpperCase() +
//                                   e.name.substring(1),
//                             )
//                             .toList(),
//                     hintText: 'ID-Type',
//                     //  isRequired: true,
//                     selectedItem:
//                         controller.idTypeController.text.isNotEmpty
//                             ? controller
//                                 .idTypeController
//                                 .text
//                                 .capitalizeFirst
//                             : null,
//                     onChanged: (value) {
//                       IDType? selectedStatus = IDType.values
//                           .firstWhere(
//                             (e) =>
//                                 e.name.toLowerCase() ==
//                                 value?.toLowerCase(),
//                             orElse: () => IDType.aadhaar,
//                           );
//                       controller.idTypeController.text =
//                           selectedStatus.name;
//                       print("Selected: $selectedStatus");
//                       print(
//                         "Selected: ${controller.idTypeController.text}",
//                       );
//                     },
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please select ID-Type';
//                       }
//                       return null;
//                     },
//                   ),
//
//                   SizedBox(height: 10),
//
//                   // Pincode
//                   Text(
//                     "ID number",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   CommonTextField(
//                     controller: controller.idNumberController,
//                     focusNode: controller.idNumberFocusNode,
//                     hintText: 'Enter ID number*',
//                     keyboardType: TextInputType.number,
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please enter ID number';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),
//
//                   Text(
//                     "Business Card",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () {
//                       controller.pickFile('businessCard');
//                     },
//                     child: DottedBorder(
//                       options: RectDottedBorderOptions(
//                         strokeWidth: 1,
//                         color: AppColor.grey.withOpacity(0.6),
//                         dashPattern: [3, 6],
//                         strokeCap: StrokeCap.square,
//                       ),
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: 30),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColor.white,
//                         ),
//                         child: Row(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/uploadIcon.png",
//                               scale: 3,
//                             ),
//                             SizedBox(width: 20),
//                             Text(
//                               "Upload Business Card",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2),
//                   Obx(() {
//                     final filePath = controller.businessFilePath;
//                     final fileName =
//                         controller.businessFileName.value;
//                     //
//                     if (filePath == null || fileName.isEmpty) {
//                       return const SizedBox.shrink();
//                     }
//                     return InkWell(
//                       onTap: () {
//                         if (controller.isLoading.value) {
//                           print("It's loading ");
//                           return;
//                         }
//                         CommonDialog.showCustomDialog(
//                           content: SizedBox(
//                             width:
//                                 MediaQuery.of(context).size.width *
//                                 0.9,
//                             height:
//                                 MediaQuery.of(context).size.height *
//                                 0.6,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child:
//                                   filePath.toLowerCase().endsWith(
//                                         '.pdf',
//                                       )
//                                       ? SfPdfViewer.file(
//                                         File(filePath),
//                                         canShowScrollHead: true,
//                                         canShowScrollStatus: true,
//                                         enableDoubleTapZooming: true,
//                                         initialZoomLevel: 1,
//                                       )
//                                       : Image.file(
//                                         File(filePath),
//                                         fit: BoxFit.contain,
//                                       ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 fileName,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   decoration:
//                                       TextDecoration.underline,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Image.asset(
//                               'assets/tick.png',
//                               scale: 2,
//                               color: Colors.green,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//
//                   Obx(() {
//                     final error = controller.businessError.value;
//                     return error.isNotEmpty
//                         ? Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             error,
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         )
//                         : SizedBox.shrink();
//                   }),
//                   SizedBox(height: 10),
//
//                   Text(
//                     "Passport Photo",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () {
//                       controller.pickFile('photo');
//                     },
//                     child: DottedBorder(
//                       options: RectDottedBorderOptions(
//                         strokeWidth: 1,
//                         color: AppColor.grey.withOpacity(0.6),
//                         dashPattern: [3, 6],
//                         strokeCap: StrokeCap.square,
//                       ),
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: 30),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColor.white,
//                         ),
//                         child: Row(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/uploadIcon.png",
//                               scale: 3,
//                             ),
//                             SizedBox(width: 20),
//                             Text(
//                               "Upload Passport Photo",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2),
//                   Obx(() {
//                     final filePath = controller.passportPhotoPath;
//                     final fileName =
//                         controller.passportPhotoName.value;
//                     //
//                     if (filePath == null || fileName.isEmpty) {
//                       return const SizedBox.shrink();
//                     }
//                     return InkWell(
//                       onTap: () {
//                         if (controller.isLoading.value) {
//                           print("It's loading ");
//                           return;
//                         }
//                         CommonDialog.showCustomDialog(
//                           content: SizedBox(
//                             width:
//                                 MediaQuery.of(context).size.width *
//                                 0.9,
//                             height:
//                                 MediaQuery.of(context).size.height *
//                                 0.6,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child:
//                                   filePath.toLowerCase().endsWith(
//                                         '.pdf',
//                                       )
//                                       ? SfPdfViewer.file(
//                                         File(filePath),
//                                         canShowScrollHead: true,
//                                         canShowScrollStatus: true,
//                                         enableDoubleTapZooming: true,
//                                         initialZoomLevel: 1,
//                                       )
//                                       : Image.file(
//                                         File(filePath),
//                                         fit: BoxFit.contain,
//                                       ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 fileName,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   decoration:
//                                       TextDecoration.underline,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Image.asset(
//                               'assets/tick.png',
//                               scale: 2,
//                               color: Colors.green,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//
//                   Obx(() {
//                     final error = controller.passportPhotoError.value;
//                     return error.isNotEmpty
//                         ? Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             error,
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         )
//                         : SizedBox.shrink();
//                   }),
//                   SizedBox(height: 10),
//
//                   Text(
//                     "ID Proof",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () {
//                       controller.pickFile('idProof');
//                     },
//                     child: DottedBorder(
//                       options: RectDottedBorderOptions(
//                         strokeWidth: 1,
//                         color: AppColor.grey.withOpacity(0.6),
//                         dashPattern: [3, 6],
//                         strokeCap: StrokeCap.square,
//                       ),
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: 30),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColor.white,
//                         ),
//                         child: Row(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/uploadIcon.png",
//                               scale: 3,
//                             ),
//                             SizedBox(width: 20),
//                             Text(
//                               "Upload ID-Proof",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2),
//                   Obx(() {
//                     final filePath = controller.idProofPath;
//                     final fileName = controller.idProofName.value;
//                     //
//                     if (filePath == null || fileName.isEmpty) {
//                       return const SizedBox.shrink();
//                     }
//                     return InkWell(
//                       onTap: () {
//                         if (controller.isLoading.value) {
//                           print("It's loading ");
//                           return;
//                         }
//                         CommonDialog.showCustomDialog(
//                           content: SizedBox(
//                             width:
//                                 MediaQuery.of(context).size.width *
//                                 0.9,
//                             height:
//                                 MediaQuery.of(context).size.height *
//                                 0.6,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child:
//                                   filePath.toLowerCase().endsWith(
//                                         '.pdf',
//                                       )
//                                       ? SfPdfViewer.file(
//                                         File(filePath),
//                                         canShowScrollHead: true,
//                                         canShowScrollStatus: true,
//                                         enableDoubleTapZooming: true,
//                                         initialZoomLevel: 1,
//                                       )
//                                       : Image.file(
//                                         File(filePath),
//                                         fit: BoxFit.contain,
//                                       ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 fileName,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   decoration:
//                                       TextDecoration.underline,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Image.asset(
//                               'assets/tick.png',
//                               scale: 2,
//                               color: Colors.green,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//
//                   Obx(() {
//                     final error = controller.idProofError.value;
//                     return error.isNotEmpty
//                         ? Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             error,
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         )
//                         : SizedBox.shrink();
//                   }),
//                   SizedBox(height: 20),
//
//                   Obx(() {
//                     return CommonButton(
//                       text: "Save",
//                       isLoading: controller.isLoading.value,
//                       onPressed: () {
//                         controller.saveVisitor();
//                       },
//                     );
//                   }),
//                   SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );

// return Padding(
//   padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 "Employees",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 120,
//             height: 40,
//             child: CommonButton(
//               text: "+ Add Visitor",
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Get.to(() => VisitorDetailScreen(), arguments: {
//                   'isFromEdit': false,
//                   'visitorID': 0,
//                 });
//               },
//               fillColor: AppColor.secondary,
//               textColor: AppColor.black,
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 16),
//       Expanded(
//         child: ListView.separated(
//           itemCount: controller.visitorListData.length,
//           shrinkWrap: true,
//           padding: EdgeInsets.only(bottom: 30),
//           physics: ScrollPhysics(),
//           itemBuilder: (context, index) {
//             VisitorListData data = controller.visitorListData[index];
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.tertiary,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: CachedNetworkImage(
//                         height: 100,
//                         width: 100,
//                         imageUrl: data.visitorPhoto ?? "",
//                         fit: BoxFit.cover,
//                         placeholder:
//                             (context, url) => const Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                         errorWidget:
//                             (context, url, error) => Image.asset(
//                               'assets/updateBanner.png',
//                               fit: BoxFit.cover,
//                             ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data.visitorName!,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             data.visitorMobile!,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         SizedBox(
//                           width: 100,
//                           child: CommonButton(
//                             text: "Remove",
//                             onPressed: () {
//                               CommonDialog.showConfirmDialog(
//                                 title: "Confirm Remove",
//                                 content:
//                                     "Are you sure you want to remove ?",
//                                 confirmText: "Yes",
//                                 cancelText: "No",
//                                 onConfirm: () {
//                                   print("Item removed");
//                                   Get.back();
//                                 },
//                                 leading: Icon(
//                                   Icons.warning_amber_rounded,
//                                   size: 48,
//                                   color: AppColor.primary,
//                                 ),
//                                 onCancel: () {
//                                   Get.back(); // Just close the dialog
//                                 },
//                               );
//                             },
//                             fillColor: AppColor.white,
//                             textColor: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         SizedBox(
//                           width: 100,
//                           child: CommonButton(
//                             text: "Edit",
//                             onPressed: () {
//                               Get.to(() => VisitorDetailScreen(), arguments: {
//                                 'isFromEdit': true,
//                                 'visitorID': data.visitorID,
//                               });
//                             },
//                             fillColor: AppColor.secondary,
//                             textColor: AppColor.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return SizedBox(height: 15);
//           },
//         ),
//       ),
//     ],
//   ),
// );
