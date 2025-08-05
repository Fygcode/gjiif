import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tjw1/common_widget/tap_outside_unfocus.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/ui/views/edit_visitor/edit_visitor_controller.dart';
import 'package:tjw1/ui/widgets/common_file_picker_box.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../core/enum/view_state.dart';
import '../../../core/model/tjw/designation_response.dart';
import '../../widgets/file_preview_widget.dart';

class EditVisitorScreen extends StatefulWidget {
  const EditVisitorScreen({super.key});

  @override
  State<EditVisitorScreen> createState() => _EditVisitorScreenState();
}

class _EditVisitorScreenState extends State<EditVisitorScreen> {
  final EditVisitorController controller = Get.put(EditVisitorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
        child: Stack(
          children: [
            TapOutsideUnFocus(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Form(
                  key: controller.editFormKey,
               //   autovalidateMode: AutovalidateMode.onUserInteraction,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Visitor Details",
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
                              Obx(() {
                                return CommonDropdown<String>(
                                  items:
                                      Gender.values
                                          .map(
                                            (e) =>
                                                e.name[0].toUpperCase() +
                                                e.name.substring(1),
                                          )
                                          .toList(),
                                  hintText: 'Gender',
                                  selectedItem:
                                      controller.gender.value.isNotEmpty
                                          ? controller.gender.value.capitalizeFirst
                                          : null,
                                  onChanged: (value) {
                                    final selected = Gender.values.firstWhere(
                                      (e) =>
                                          e.name.toLowerCase() ==
                                          value?.toLowerCase(),
                                      orElse: () => Gender.male,
                                    );
                                    controller.gender.value = selected.name;
                                    controller.genderController.text =
                                        selected.name;
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please select gender';
                                    }
                                    return null;
                                  },
                                );
                              }),

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
                              Obx(
                                () => CommonDropdown<DesignationData>(
                                  items: controller.designationList.toList(),
                                  hintText: 'Select designation*',
                                  selectedItem: (() {
                                    final id = int.tryParse(controller.designationID.value ?? '0');
                                    if (id == null || id == 0) return null;

                                    try {
                                      return controller.designationList.firstWhere((e) => e.designationID == id);
                                    } catch (_) {
                                      return null;
                                    }
                                  })(),
                                  itemAsString: (state) => state.designation ?? '',
                                  compareFn:
                                      (a, b) => a.designationID == b.designationID,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.designationController.text =
                                          value.designation ?? '';
                                      controller.designationID.value =
                                          value.designationID.toString() ?? "";
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null ||
                                        val.designation?.isEmpty == true) {
                                      return 'Please designation state';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Obx(() {
                                final isChanged = controller.phoneNumberController.text != controller.getPhoneNumberDB.value;
                                return Row(
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    if (isChanged || !controller.isPhoneVerified.value)
                                      Text(
                                        "Unverified",
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                      ),
                                    if (controller.isPhoneVerified.value && !isChanged)
                                      Row(
                                        children: [
                                          Text(
                                            "Verified",
                                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.verified_rounded, color: Colors.green),
                                        ],
                                      ),
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
                                        isLoading: controller.isOTPLoading.value,
                                        isDisabled: !controller.isPhoneValid.value || controller.isPhoneVerified.value,
                                        onPressed: () async {
                                          controller.otpController.clear();
                                          if (controller.isOTPLoading.value) return;
                                          print("Open OPT Dialog");
                                          final success =
                                              await controller.sendOtp();
                                          if (success) {
                                            print(
                                              "OTP sent successfully, opening dialog...",
                                            );
                                            controller.openDialogBox();
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "Failed to send OTP",
                                            );
                                          }
                                        },
                                        fillColor: AppColor.secondary,
                                        textColor: AppColor.black,
                                      ),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (controller.phoneNumberController.text !=
                                      controller.getPhoneNumberDB.value) {
                                    controller.isPhoneVerified.value = false;
                                  }else{
                                    controller.isPhoneVerified.value = true;
                                  }
                                },
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
                              Obx(() {
                                return CommonDropdown<String>(
                                  items:
                                      IDType.values
                                          .map(
                                            (e) =>
                                                e.name[0].toUpperCase() +
                                                e.name.substring(1),
                                          )
                                          .toList(),
                                  hintText: 'ID-Type',
                                  selectedItem:
                                      controller.idType.value.isNotEmpty
                                          ? controller.idType.value.capitalizeFirst
                                          : null,
                                  onChanged: (value) {
                                    final selected = IDType.values.firstWhere(
                                      (e) =>
                                          e.name.toLowerCase() ==
                                          value?.toLowerCase(),
                                      orElse: () => IDType.aadhaar,
                                    );
                                    controller.idType.value = selected.name;
                                    controller.idTypeController.text =
                                        selected.name;
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please select ID-Type';
                                    }
                                    return null;
                                  },
                                );
                              }),
                              SizedBox(height: 10),
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
                                maxLength: 20,
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

                              CommonFilePickerBox(
                                label: "Upload Business Card",
                                fileKey: "businessCard",
                                isLoading: controller.isUploadLoading,
                                uploadingKey: controller.uploadingFileKey,
                                onPick: controller.pickFile,
                              ),

                              SizedBox(height: 2),
                              FilePreviewWidget(
                                filePath: controller.businessFilePath,
                                fileName: controller.businessFileName,
                                errorText: controller.businessError,
                                isLoading: controller.isLoading,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Passport Photo",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),

                              CommonFilePickerBox(
                                label: "Upload Passport Photo",
                                fileKey: "photo",
                                isLoading: controller.isUploadLoading,
                                uploadingKey: controller.uploadingFileKey,
                                onPick: controller.pickFile,
                              ),

                              SizedBox(height: 2),
                              FilePreviewWidget(
                                filePath: controller.passportPhotoPath,
                                fileName: controller.passportPhotoName,
                                errorText: controller.passportPhotoError,
                                isLoading: controller.isLoading,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ID Proof",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),

                              CommonFilePickerBox(
                                label: "Upload ID-Proof",
                                fileKey: "idProof",
                                isLoading: controller.isUploadLoading,
                                uploadingKey: controller.uploadingFileKey,
                                onPick: controller.pickFile,
                              ),

                              SizedBox(height: 2),
                              FilePreviewWidget(
                                filePath: controller.idProofPath,
                                fileName: controller.idProofName,
                                errorText: controller.idProofError,
                                isLoading: controller.isLoading,
                              ),

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

            Obx(() {
              if (controller.isLoading.value ) {
                return Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),


      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() {
            return CommonButton(
              text: "Save",
              isLoading: controller.isUploadLoading.value || controller.isLoading.value,
              onPressed: () {
                controller.saveUpdatedVisitor(context);
              },
            );
          }),
        ),
      ),
    );
  }
}
