import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dialog.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/enum/view_state.dart';
import '../../../core/res/colors.dart';
import 'company_controller.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyController controller = Get.put(CompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        bottom: false,
        child: TapOutsideUnFocus(
          child: Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: Form(
              key: controller.formKeyCompany,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Organization Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded (
                    child: SingleChildScrollView (
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company GSTIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.companyGstController,
                            focusNode: controller.companyGstFocusNode,
                            hintText: 'Enter Company GST*',
                            enabled: false,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter GST number';
                              }
                              // RegExp gstRegExp = RegExp(
                              //   r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                              // );
                              // if (!gstRegExp.hasMatch(val.toUpperCase())) {
                              //   return 'Please enter a valid GST number';
                              // }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // Company Type
                          Text(
                            "Company Type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),

                          CommonDropdown<String>(
                            items:
                            CompanyType.values
                                .map(
                                  (e) =>
                              e.name[0].toUpperCase() +
                                  e.name.substring(1),
                            )
                                .toList(),
                            hintText: 'Company Type*',
                            selectedItem:
                            controller.companyTypeController.text.isNotEmpty
                                ? controller.companyTypeController.text
                                : null,
                            onChanged: (value) {
                              if (value != null) {
                                CompanyType selectedStatus = CompanyType.values
                                    .firstWhere(
                                      (e) =>
                                  e.name.toLowerCase() ==
                                      value.toLowerCase(),
                                  orElse: () => CompanyType.Proprietorship,
                                );
                                controller.companyTypeController.text = value;
                                print("Selected: $selectedStatus");
                                print("Selected Text: ${controller.companyTypeController.text}",);
                              }
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please select company type';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10),

                          // Company Name
                          Text(
                            "Company Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.companyNameController,
                            focusNode: controller.companyNameFocusNode,
                            hintText: 'Enter Company Name*',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter company name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // Communication Address
                          Text(
                            "Communication Address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.communicationAddressController,
                            focusNode: controller.communicationAddressFocusNode,
                            hintText: 'Enter Communication Address*',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter communication address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // City
                          Text(
                            "City",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.cityController,
                            focusNode: controller.cityFocusNode,
                            hintText: 'Enter City*',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // State
                          Text(
                            "State",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.stateController,
                            focusNode: controller.stateFocusNode,
                            hintText: 'Enter State*',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter state';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Pincode",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.pincodeController,
                            focusNode: controller.pincodeFocusNode,
                            hintText: 'Enter Pincode*',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter pincode';
                              }
                              if (val.length != 6) {
                                return 'Pincode must be 6 digits';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // Landline
                          Text(
                            "Landline",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField.phone(
                            controller: controller.landlineController,
                            focusNode: controller.landlineFocusNode,
                            hintText: 'Enter Landline *',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter landline number';
                              }
                              RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
                              if (!phoneRegExp.hasMatch(val)) {
                                return 'Please enter a valid landline number';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10),

                          // Upload GST
                          Text(
                            "Upload GST Copy",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              controller.pickFile('gstCopy');
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
                                      "Upload GST-Copy",
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
                          //   final name = controller.gstCopyFileName.value;
                          //   return name.isNotEmpty
                          //       ? Row(
                          //     children: [
                          //       Text(name, style: TextStyle(fontSize: 14)),
                          //       SizedBox(width: 6),
                          //       Image.asset(
                          //         'assets/tick.png',
                          //         scale: 2,
                          //         color: Colors.green,
                          //       ),
                          //     ],
                          //   )
                          //       : SizedBox.shrink(); // Returns an empty widget if name is empty
                          // }),
                          Obx(() {
                            final filePath = controller.gstCopyFilePath;
                            final fileName = controller.gstCopyFileName.value;
                            //
                            if (filePath == null || fileName.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return InkWell (
                              onTap: () {
                                if(controller.isLoading.value){
                                  print("It's loading ");
                                  return;
                                }
                                CommonDialog.showCustomDialog(
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: filePath.toLowerCase().endsWith('.pdf')
                                          ? SfPdfViewer.file(
                                        File(filePath),
                                        canShowScrollHead: true,
                                        canShowScrollStatus: true,
                                        enableDoubleTapZooming: true,
                                        initialZoomLevel: 1,
                                      )
                                          : Image.file(
                                        File(filePath),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded (
                                      child: Text(
                                        fileName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      'assets/tick.png',
                                      scale: 2,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          Obx(() {
                            final error = controller.gstCopyError.value;
                            return error.isNotEmpty
                                ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                error,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                                : SizedBox.shrink();
                          }),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, bottom: 40),
                            child:  Obx((){
                              return CommonButton(
                                text: "Save",
                                isLoading: controller.isLoading.value,
                                onPressed: () {
                                  controller.saveCompany();
                                },
                              );
                            })
                          ),
                        ],
                      ),
                    ),
                  ),





                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
