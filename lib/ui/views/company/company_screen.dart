import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dialog.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
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
    return Scaffold(
      backgroundColor: AppColor.background,
        body: SafeArea(
          bottom: false,
          child: Obx(() {
            return Stack(
              children: [
                TapOutsideUnFocus(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Text(
                          "Organization Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: controller.formKeyCompany,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: _buildFormFields(),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),

                if (controller.isLoading.value &&
                    (controller.stateList.isEmpty ||
                        controller.companyTypeList.isEmpty))
                  Container(
                    color: Colors.black.withOpacity(0.2), // Dim background
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),

    );
  }

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
            hintText: 'Enter State*',
            selectedItem: controller.stateList.firstWhere(
              (e) => e.stateID == int.tryParse(controller.stateId.value ?? '0'),
              orElse:
                  () => StateData(stateID: 0, stateName: '', countryID: null),
            ),
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
        FilePreviewWidget(
          filePath: controller.gstCopyFilePath,
          fileName: controller.gstCopyFileName,
          errorText: controller.gstCopyError,
          isLoading: controller.isLoading,
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 40),
          child: Obx(() {
            return CommonButton(
              text: "Save",
              isLoading: controller.isLoading.value,
              onPressed: () {
                controller.saveCompany();
              },
            );
          }),
        ),
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
