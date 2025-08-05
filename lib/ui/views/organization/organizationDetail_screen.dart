// import 'dart:io';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
// import 'package:tjw1/core/model/tjw/stateList.dart';
// import 'package:tjw1/ui/widgets/common_file_picker_box.dart';
// import 'package:tjw1/ui/widgets/file_preview_widget.dart';
//
// import '../../../common_widget/common_button.dart';
// import '../../../common_widget/common_dialog.dart';
// import '../../../common_widget/common_dropdown.dart';
// import '../../../common_widget/common_text_field.dart';
// import '../../../common_widget/tap_outside_unfocus.dart';
// import '../../../core/enum/view_state.dart';
// import '../../../core/res/colors.dart';
// import 'organizationDetail_controller.dart';
//
// class OrganizationDetailScreen extends StatefulWidget {
//   OrganizationDetailScreen({super.key});
//
//   @override
//   State<OrganizationDetailScreen> createState() =>
//       _OrganizationDetailScreenState();
// }
//
// class _OrganizationDetailScreenState extends State<OrganizationDetailScreen> {
//   final OrganizationDetailController controller = Get.put(
//     OrganizationDetailController(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: AppColor.background,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColor.background,
//         resizeToAvoidBottomInset: false,
//         extendBody: true,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leadingWidth: 130,
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: Image.asset('assets/GJIIF_Logo.png', height: 60, width: 60),
//           ),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/splash_background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           bottom: false,
//           child: Obx(() {
//             return Stack(
//               children: [
//                 TapOutsideUnFocus(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 20,
//                           left: 20,
//                           right: 20,
//                         ),
//                         child: Text(
//                           "Company Detail",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//
//                       Expanded(
//                         child: SingleChildScrollView(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Form(
//                             key: controller.formKeyOrganization,
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             child: _buildFormFields(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 if (controller.isLoading.value)
//                   Container(
//                     color: Colors.black.withOpacity(0.2), // Dim background
//                     child: const Center(child: CircularProgressIndicator()),
//                   ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabeledText("Company GSTIN"),
//         CommonTextField(
//           controller: controller.companyGstController,
//           focusNode: controller.companyGstFocusNode,
//           hintText: 'Enter Company GST*',
//           enabled: false,
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter GST number';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Company Type"),
//         Obx(
//           () => CommonDropdown<CompanyTypeData>(
//             items: controller.companyTypeList,
//             hintText: 'Select Company Type*',
//             selectedItem: controller.selectedCompanyType,
//             itemAsString: (state) => state.companyType ?? '',
//             compareFn: (a, b) => a.id == b.id,
//             onChanged: (value) {
//               if (value != null) {
//                 controller.companyTypeController.text = value.companyType ?? '';
//                 controller.companyTypeId.value = value.id.toString() ?? "";
//               }
//             },
//             validator: (val) {
//               if (val == null || val.companyType?.isEmpty == true) {
//                 return 'Please select company type';
//               }
//               return null;
//             },
//           ),
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Company Name"),
//         CommonTextField(
//           controller: controller.companyNameController,
//           focusNode: controller.companyNameFocusNode,
//           hintText: 'Enter Company Name*',
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter company name';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Communication Address"),
//         CommonTextField(
//           controller: controller.communicationAddressController,
//           focusNode: controller.communicationAddressFocusNode,
//           hintText: 'Enter Communication Address*',
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter communication address';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("City"),
//         CommonTextField(
//           controller: controller.cityController,
//           focusNode: controller.cityFocusNode,
//           hintText: 'Enter City*',
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter city';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("State"),
//
//         Obx(
//           () => CommonDropdown<StateData>(
//             items: controller.stateList.toList(),
//             hintText: 'Select State*',
//             selectedItem:
//                 (() {
//                   final id = int.tryParse(controller.stateId.value ?? '0');
//                   if (id == null || id == 0) return null;
//                   return controller.stateList.firstWhere(
//                     (e) => e.stateID == id,
//                     orElse:
//                         () => StateData(
//                           stateID: 0,
//                           stateName: '',
//                           countryID: null,
//                         ),
//                   );
//                 })(),
//             itemAsString: (state) => state.stateName ?? '',
//             compareFn: (a, b) => a.stateID == b.stateID,
//             onChanged: (value) {
//               if (value != null) {
//                 controller.stateController.text = value.stateName ?? '';
//                 controller.stateId.value = value.stateID.toString() ?? "";
//               }
//             },
//             validator: (val) {
//               if (val == null || val.stateName?.isEmpty == true) {
//                 return 'Please select state';
//               }
//               return null;
//             },
//           ),
//         ),
//
//         SizedBox(height: 10),
//         _buildLabeledText("District"),
//         CommonTextField(
//           controller: controller.districtController,
//           focusNode: controller.districtFocusNode,
//           hintText: 'Enter District*',
//           textInputAction: TextInputAction.next,
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter district';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Pincode"),
//         CommonTextField(
//           controller: controller.pincodeController,
//           focusNode: controller.pincodeFocusNode,
//           hintText: 'Enter Pincode*',
//           keyboardType: TextInputType.number,
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter pincode';
//             }
//             if (val.length != 6) {
//               return 'Pincode must be 6 digits';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Landline"),
//         CommonTextField.phone(
//           controller: controller.landlineController,
//           focusNode: controller.landlineFocusNode,
//           hintText: 'Enter Landline *',
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Please enter landline number';
//             }
//             RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
//             if (!phoneRegExp.hasMatch(val)) {
//               return 'Please enter a valid landline number';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 10),
//         _buildLabeledText("Upload GST Copy"),
//
//         CommonFilePickerBox(
//           label: "Upload GST-Copy",
//           fileKey: "gstCopy",
//           isLoading: controller.isUploadLoading,
//           uploadingKey: controller.uploadingFileKey,
//           onPick: controller.pickFile,
//         ),
//
//         SizedBox(height: 2),
//
//         FilePreviewWidget(
//           filePath: controller.gstCopyFilePath,
//           fileName: controller.gstCopyFileName,
//           errorText: controller.gstCopyError,
//           isLoading: controller.isLoading,
//         ),
//
//         SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.only(top: 25, bottom: 40),
//           child: Obx(() {
//             return CommonButton(
//               text: "Save",
//             //  isLoading: controller.isLoading.value,
//               isLoading: controller.isLoading.value || controller.isUploadLoading.value,
//               onPressed: () {
//                 controller.saveOrganization();
//               },
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLabeledText(String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 4),
//     child: Text(
//       text,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/ui/widgets/common_file_picker_box.dart';
import 'package:tjw1/ui/widgets/file_preview_widget.dart';
import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dropdown.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import 'organizationDetail_controller.dart';

class OrganizationDetailScreen extends StatelessWidget {
  OrganizationDetailScreen({super.key});

  final OrganizationDetailController controller = Get.put(
    OrganizationDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.background,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.background,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: _buildAppBar(),
        body: SafeArea(
          bottom: false,
          child: Obx(
            () => Stack(
              children: [
                TapOutsideUnFocus(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle("Company Detail"),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: controller.formKeyOrganization,
                        //    autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: _buildFormFields(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isLoading.value) _buildLoadingOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leadingWidth: 130,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Image.asset('assets/GJIIF_Logo.png', height: 60, width: 60),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/splash_background.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

  Widget _buildTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 16),
    child: Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildLoadingOverlay() => Container(
    color: Colors.black.withOpacity(0.2),
    child: const Center(child: CircularProgressIndicator()),
  );

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledField(
          "Company GSTIN",
          _buildDisabledTextField(
            controller.companyGstController,
            controller.companyGstFocusNode,
            'Enter Company GST*',
          ),
        ),
        _buildLabeledField(
          "Company Type",
          Obx(() => _buildCompanyTypeDropdown()),
        ),
        _buildLabeledField(
          "Company Name",
          _buildTextField(
            controller.companyNameController,
            controller.companyNameFocusNode,
            'Enter Company Name*',
          ),
        ),
        _buildLabeledField(
          "Communication Address",
          _buildTextField(
            controller.communicationAddressController,
            controller.communicationAddressFocusNode,
            'Enter Communication Address*',
          ),
        ),
        _buildLabeledField(
          "City",
          _buildTextField(
            controller.cityController,
            controller.cityFocusNode,
            'Enter City*',
          ),
        ),
        _buildLabeledField("State", Obx(() => _buildStateDropdown())),
        _buildLabeledField(
          "District",
          _buildTextField(
            controller.districtController,
            controller.districtFocusNode,
            'Enter District*',
          ),
        ),
        _buildLabeledField(
          "Pincode",
          _buildNumberField(
            controller.pincodeController,
            controller.pincodeFocusNode,
            'Enter Pincode*',
          ),
        ),
        _buildLabeledField("Landline", _buildPhoneField()),
        _buildLabeledField("Upload GST Copy", _buildFileSection()),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 40),
          child: Obx(
            () => CommonButton(
              text: "Save",
              isLoading:
                  controller.isLoading.value ||
                  controller.isUploadLoading.value,
              onPressed: controller.saveOrganization,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField(String label, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        child,
      ],
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
  ) => CommonTextField(
    controller: controller,
    focusNode: focusNode,
    hintText: hint,
    validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
  );

  Widget _buildDisabledTextField(
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
  ) => CommonTextField(
    controller: controller,
    focusNode: focusNode,
    hintText: hint,
    enabled: false,
    validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
  );

  Widget _buildNumberField(
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
  ) => CommonTextField(
    controller: controller,
    focusNode: focusNode,
    hintText: hint,
    keyboardType: TextInputType.number,
    maxLength: 6,
    validator:
        (val) =>
            val == null || val.isEmpty || val.length != 6
                ? 'Pincode must be 6 digits'
                : null,
  );

  Widget _buildPhoneField() => CommonTextField.phone(
    controller: controller.landlineController,
    focusNode: controller.landlineFocusNode,
    hintText: 'Enter Landline *',
    validator: (val) {
      if (val == null || val.isEmpty) return 'Please enter landline number';
      if (!RegExp(r'^[0-9]{10}$').hasMatch(val)) {         // RegExp(r'^[0-9]{6,12}$')   allow landlines with STD code (like 0441234567),  // Accepts between 6 to 12 digits

        return 'Please enter a valid number';
      }
      return null;
    },
  );

  Widget _buildCompanyTypeDropdown() => CommonDropdown<CompanyTypeData>(
    items: controller.companyTypeList,
    hintText: 'Select Company Type*',
    selectedItem: controller.selectedCompanyType,
    itemAsString: (state) => state.companyType ?? '',
    compareFn: (a, b) => a.id == b.id,
    onChanged: (value) {
      if (value != null) {
        controller.companyTypeController.text = value.companyType ?? '';
        controller.companyTypeId.value = value.id.toString();
      }
    },
    validator:
        (val) =>
            val == null || val.companyType?.isEmpty == true
                ? 'Please select company type'
                : null,
  );

  Widget _buildStateDropdown() => CommonDropdown<StateData>(
    items: controller.stateList.toList(),
    hintText: 'Select State*',
    selectedItem: controller.getSelectedState(),
    itemAsString: (state) => state.stateName ?? '',
    compareFn: (a, b) => a.stateID == b.stateID,
    onChanged: (value) {
      if (value != null) {
        controller.stateController.text = value.stateName ?? '';
        controller.stateId.value = value.stateID.toString();
      }
    },
    validator:
        (val) =>
            val == null || val.stateName?.isEmpty == true
                ? 'Please select state'
                : null,
  );

  Widget _buildFileSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CommonFilePickerBox(
        label: "Upload GST-Copy",
        fileKey: "gstCopy",
        isLoading: controller.isUploadLoading,
        uploadingKey: controller.uploadingFileKey,
        onPick: controller.pickFile,
      ),
      const SizedBox(height: 2),
      FilePreviewWidget(
        filePath: controller.gstCopyFilePath,
        fileName: controller.gstCopyFileName,
        errorText: controller.gstCopyError,
        isLoading: controller.isLoading,
      ),
    ],
  );
}
