import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dialog.dart';
import 'package:tjw1/ui/views/visitor_detail/visitor_detail_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/enum/view_state.dart';
import '../../../core/res/colors.dart';

class VisitorDetailScreen extends StatefulWidget {
  const VisitorDetailScreen({super.key});

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  final VisitorDetailController controller = Get.put(VisitorDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: false,
      extendBody: true,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leadingWidth: 80,
      //   leading: Image.asset('assets/logo.png', height: 60, width: 60),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage('assets/splash_background.png'),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ),
      // ),
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
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company GSTIN
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonDropdown<String>(
                            items:
                                Gender.values
                                    .map(
                                      (e) =>
                                          e.name[0].toUpperCase() +
                                          e.name.substring(1),
                                    )
                                    .toList(),
                            hintText: 'Gender',
                            //  isRequired: true,
                            selectedItem:
                                controller.genderController.text.isNotEmpty
                                    ? controller
                                        .genderController
                                        .text
                                        .capitalizeFirst
                                    : null,
                            onChanged: (value) {
                              Gender? selectedStatus = Gender.values.firstWhere(
                                (e) =>
                                    e.name.toLowerCase() ==
                                    value?.toLowerCase(),
                                orElse: () => Gender.male,
                              );
                              controller.genderController.text =
                                  selectedStatus.name;
                              print("Selected: $selectedStatus");
                              print(
                                "Selected: ${controller.genderController.text}",
                              );
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonTextField(
                            controller: controller.designationController,
                            focusNode: controller.designationFocusNode,
                            hintText: 'Enter Designation*',
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter Designation ';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          Obx(() {
                            return Row(
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                controller.isPhoneVerified.value
                                    ? Text(
                                      "Verified",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  width:
                                      controller.isPhoneVerified.value ? 6 : 0,
                                ),
                                controller.isPhoneVerified.value
                                    ? Icon(
                                      Icons.verified_rounded,
                                      color: Colors.green,
                                    )
                                    : SizedBox.shrink(),
                              ],
                            );
                          }),
                          SizedBox(height: 4),
                          CommonTextField.phone(
                            controller: controller.phoneNumberController,
                            focusNode: controller.phoneNumberFocusNode,
                            hintText: 'Phone Number *',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                right: 5,
                                top: 5,
                                bottom: 5,
                              ),
                              child: SizedBox(
                                width: 100,
                                height: 30,
                                child: Obx(
                                  () => CommonButton(
                                    text: "Send OTP",
                                    padding: EdgeInsets.zero,
                                    isDisabled: !controller.isPhoneValid.value,
                                    onPressed: () {
                                      controller.otpController.clear();
                                      controller.openDialogBox();
                                    },
                                    fillColor: AppColor.secondary,
                                    textColor: AppColor.black,
                                  ),
                                ),
                              ),
                            ),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          CommonDropdown<String>(
                            items:
                                IDType.values
                                    .map(
                                      (e) =>
                                          e.name[0].toUpperCase() +
                                          e.name.substring(1),
                                    )
                                    .toList(),
                            hintText: 'ID-Type',
                            //  isRequired: true,
                            selectedItem:
                                controller.idTypeController.text.isNotEmpty
                                    ? controller
                                        .idTypeController
                                        .text
                                        .capitalizeFirst
                                    : null,
                            onChanged: (value) {
                              IDType? selectedStatus = IDType.values.firstWhere(
                                (e) =>
                                    e.name.toLowerCase() ==
                                    value?.toLowerCase(),
                                orElse: () => IDType.aadhaar,
                              );
                              controller.idTypeController.text =
                                  selectedStatus.name;
                              print("Selected: $selectedStatus");
                              print(
                                "Selected: ${controller.idTypeController.text}",
                              );
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/uploadIcon.png",
                                      scale: 3,
                                    ),
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
                          //   final name = controller.businessFileName.value;
                          //   return name.isNotEmpty
                          //       ? Row(
                          //         children: [
                          //           Text(name, style: TextStyle(fontSize: 14)),
                          //           SizedBox(width: 6),
                          //           Image.asset(
                          //             'assets/tick.png',
                          //             scale: 2,
                          //             color: Colors.green,
                          //           ),
                          //         ],
                          //       )
                          //       : SizedBox.shrink(); // Returns an empty widget if name is empty
                          // }),

                          Obx(() {
                            final filePath = controller.businessFilePath;
                            final fileName = controller.businessFileName.value;
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
                            final error = controller.businessError.value;
                            return error.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink();
                          }),
                          SizedBox(height: 10),

                          Text(
                            "Passport Photo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/uploadIcon.png",
                                      scale: 3,
                                    ),
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
                          //   final name = controller.passportPhotoName.value;
                          //   return name.isNotEmpty
                          //       ? Row(
                          //         children: [
                          //           Text(name, style: TextStyle(fontSize: 14)),
                          //           SizedBox(width: 6),
                          //           Image.asset(
                          //             'assets/tick.png',
                          //             scale: 2,
                          //             color: Colors.green,
                          //           ),
                          //         ],
                          //       )
                          //       : SizedBox.shrink(); // Returns an empty widget if name is empty
                          // }),

                          Obx(() {
                            final filePath = controller.passportPhotoPath;
                            final fileName = controller.passportPhotoName.value;
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
                            final error = controller.passportPhotoError.value;
                            return error.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink();
                          }),
                          SizedBox(height: 10),

                          Text(
                            "ID Proof",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/uploadIcon.png",
                                      scale: 3,
                                    ),
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
                          //   final name = controller.idProofName.value;
                          //   return name.isNotEmpty
                          //       ? Row(
                          //         children: [
                          //           Text(name, style: TextStyle(fontSize: 14)),
                          //           SizedBox(width: 6),
                          //           Image.asset(
                          //             'assets/tick.png',
                          //             scale: 2,
                          //             color: Colors.green,
                          //           ),
                          //         ],
                          //       )
                          //       : SizedBox.shrink();
                          // }),
                          Obx(() {
                            final filePath = controller.idProofPath;
                            final fileName = controller.idProofName.value;
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
                            final error = controller.idProofError.value;
                            return error.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink();
                          }),
                          SizedBox(height: 100),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx((){
            return CommonButton(
              text: "Save",
              isLoading: controller.isLoading.value,
              onPressed: () {
                controller.saveVisitor();
              },
            );
          })
        ),
      ),
    );
  }
}

// final phone = controller.phoneNumberController.text.trim();
//
// if (phone.isEmpty) {
//   Fluttertoast.showToast(msg: "Please enter phone number");
//   return;
// }
//
// final phoneRegExp = RegExp(r'^[0-9]{10}$');
// if (!phoneRegExp.hasMatch(phone)) {
//   Fluttertoast.showToast(msg: "Please enter a valid phone number");
//   return;
// }
