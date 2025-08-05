import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dialog.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/ui/widgets/common_file_picker_box.dart';
import 'package:tjw1/ui/widgets/file_preview_widget.dart';

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
  void initState() {
    controller.loadGstFromStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: AppColor.background,
    //   resizeToAvoidBottomInset: true,
    //   body:
    //   SafeArea(
    //     child: Stack(
    //       children: [
    //         TapOutsideUnFocus(
    //           child: SingleChildScrollView(
    //             padding: const EdgeInsets.symmetric(horizontal: 20),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const SizedBox(height: 20),
    //                 const Text(
    //                   "Company Detail",
    //                   style: TextStyle(
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 Form(
    //                   key: controller.formKeyCompany,
    //              //     autovalidateMode: AutovalidateMode.onUserInteraction,
    //                   child: _buildFormFields(),
    //                 ),
    //                 const SizedBox(height: 100), // Some bottom padding to avoid keyboard overlap
    //               ],
    //             ),
    //           ),
    //         ),
    //
    //         /// Loading overlay
    //         Obx(() {
    //           if (controller.isLoading.value ) {
    //             return Container(
    //               color: Colors.black.withOpacity(0.2),
    //               child: const Center(
    //                 child: CircularProgressIndicator(),
    //               ),
    //             );
    //           } else {
    //             return const SizedBox.shrink();
    //           }
    //         }),
    //       ],
    //     ),
    //   ),
    // );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.background,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: TapOutsideUnFocus(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Form(
                        key: controller.formKeyCompany,
                        child: _buildFormFields(),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return controller.showSaveButton.value
                      ? Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: CommonButton(
                          text: "Save",
                          isLoading: controller.isLoading.value || controller.isUploadLoading.value,
                          onPressed: () {
                            controller.saveCompany();
                          },
                        ),
                      )
                      : SizedBox.shrink();
                }),
              ],
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     bottom: false,
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         return Stack(
  //           children: [
  //             TapOutsideUnFocus(
  //               child: SingleChildScrollView(
  //                 padding: EdgeInsets.only(
  //                   left: 20,
  //                   right: 20,
  //                   bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //                 ),
  //                 child: ConstrainedBox(
  //                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
  //                   child: IntrinsicHeight(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(height: 20),
  //                         const Text(
  //                           "Company Detail",
  //                           style: TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Form(
  //                           key: controller.formKeyCompany,
  //                           autovalidateMode: AutovalidateMode.onUserInteraction,
  //                           child: _buildFormFields(),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //             // Only this part uses observables
  //             Obx(() {
  //               if (controller.isLoading.value &&
  //                   (controller.stateList.isEmpty || controller.companyTypeList.isEmpty)) {
  //                 return Container(
  //                   color: Colors.black.withOpacity(0.2),
  //                   child: const Center(
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 );
  //               } else {
  //                 return const SizedBox.shrink();
  //               }
  //             }),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledText("Company GSTIN"),
        CommonTextField(
          controller: controller.companyGstController,
          focusNode: controller.companyGstFocusNode,
          hintText: 'Enter Company GST*',
          enabled: false,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please enter GST number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        _buildLabeledText("Company Type"),
        Obx(
          () => CommonDropdown<CompanyTypeData>(
            items: controller.companyTypeList,
            hintText: 'Select Company Type*',
            selectedItem: controller.selectedCompanyType,
            itemAsString: (state) => state.companyType ?? '',
            compareFn: (a, b) => a.id == b.id,
            onChanged: (value) {
              if (value != null) {
                controller.companyTypeController.text = value.companyType ?? '';
                controller.companyTypeId.value = value.id.toString() ?? "";
              }
            },
            validator: (val) {
              if (val == null || val.companyType?.isEmpty == true) {
                return 'Please select company type';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 10),
        _buildLabeledText("Company Name"),
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
        _buildLabeledText("Communication Address"),
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
        _buildLabeledText("City"),
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
        _buildLabeledText("State"),
        Obx(
          () => CommonDropdown<StateData>(
            items: controller.stateList,
            hintText: 'Select State*',
            selectedItem:
                (() {
                  final id = int.tryParse(controller.stateId.value ?? '0');
                  if (id == null || id == 0) return null;
                  return controller.stateList.firstWhere(
                    (e) => e.stateID == id,
                    orElse:
                        () => StateData(
                          stateID: 0,
                          stateName: '',
                          countryID: null,
                        ),
                  );
                })(),
            itemAsString: (state) => state.stateName ?? '',
            compareFn: (a, b) => a.stateID == b.stateID,
            onChanged: (value) {
              if (value != null) {
                controller.stateController.text = value.stateName ?? '';
                controller.stateId.value = value.stateID.toString() ?? "";
              }
            },
            validator: (val) {
              if (val == null || val.stateName?.isEmpty == true) {
                return 'Please select state';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 10),
        _buildLabeledText("District"),
        CommonTextField(
          controller: controller.districtController,
          focusNode: controller.districtFocusNode,
          hintText: 'Enter District*',
          textInputAction: TextInputAction.next,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please enter district';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        _buildLabeledText("Pincode"),
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
        _buildLabeledText("Landline"),
        CommonTextField.phone(
          controller: controller.landlineController,
          focusNode: controller.landlineFocusNode,
          hintText: 'Enter Landline *',
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please enter landline number';
            }
            // RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
            // if (!phoneRegExp.hasMatch(val)) {
            //   return 'Please enter a valid landline number';
            // }
            return null;
          },
        ),
        SizedBox(height: 10),
        _buildLabeledText("Upload GST Copy"),
        // GestureDetector(
        //   onTap: () {
        //     if (controller.isUploadLoading.value) return;
        //     controller.pickFile('gstCopy');
        //   },
        //   child: DottedBorder(
        //     options: RectDottedBorderOptions(
        //       strokeWidth: 1,
        //       color: AppColor.grey.withOpacity(0.6),
        //       dashPattern: [3, 6],
        //       strokeCap: StrokeCap.square,
        //     ),
        //     child: Container(
        //       width: double.infinity,
        //       padding: EdgeInsets.symmetric(vertical: 30),
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(color: AppColor.white),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Image.asset("assets/uploadIcon.png", scale: 3),
        //           SizedBox(width: 20),
        //           Text(
        //             "Upload GST-Copy",
        //             style: TextStyle(
        //               color: Colors.grey,
        //               fontSize: 16,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        CommonFilePickerBox(
          label: "Upload GST-Copy",
          fileKey: "gstCopy",
          isLoading: controller.isUploadLoading,
          uploadingKey: controller.uploadingFileKey,
          onPick: controller.pickFile,
        ),



        SizedBox(height: 2),
        FilePreviewWidget(
          filePath: controller.gstCopyFilePath,
          fileName: controller.gstCopyFileName,
          errorText: controller.gstCopyError,
          isLoading: controller.isLoading,
        ),
        SizedBox(height: 100),
        // Padding(
        //   padding: const EdgeInsets.only(top: 25, bottom: 40),
        //   child: Obx(() {
        //     return CommonButton(
        //       text: "Save",
        //       isLoading: controller.isLoading.value || controller.isUploadLoading.value,
        //       onPressed: () {
        //         controller.saveCompany();
        //       },
        //     );
        //   }),
        // ),
      ],
    );
  }

  Widget _buildLabeledText(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
