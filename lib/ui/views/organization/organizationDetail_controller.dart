import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/common_widget/common_dialog.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/core/model/tjw/fetch_company_detail.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/helper/file_upload_helper.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';

import '../dashboard/dashboard_screen.dart';

class OrganizationDetailController extends GetxController {
  final dynamic statusCode = Get.arguments;
  final TextEditingController companyGstController = TextEditingController();
  final FocusNode companyGstFocusNode = FocusNode();

  final TextEditingController companyTypeController = TextEditingController();
  final FocusNode companyTypeFocusNode = FocusNode();

  final TextEditingController companyNameController = TextEditingController();
  final FocusNode companyNameFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController communicationAddressController =
      TextEditingController();
  final FocusNode communicationAddressFocusNode = FocusNode();

  final TextEditingController cityController = TextEditingController();
  final FocusNode cityFocusNode = FocusNode();

  final TextEditingController districtController = TextEditingController();
  final FocusNode districtFocusNode = FocusNode();

  final TextEditingController stateController = TextEditingController();
  final FocusNode stateFocusNode = FocusNode();

  final TextEditingController pincodeController = TextEditingController();
  final FocusNode pincodeFocusNode = FocusNode();

  final TextEditingController landlineController = TextEditingController();
  final FocusNode landlineFocusNode = FocusNode();

  final TextEditingController uploadGstController = TextEditingController();
  final FocusNode uploadGstFocusNode = FocusNode();

  final formKeyOrganization = GlobalKey<FormState>();

  // File paths
  var gstCopyFilePath = ''.obs;

  // Reactive file names
  final RxString gstCopyFileName = ''.obs;

  // String? selectedCompanyType;

  // Error name
  var gstCopyError = ''.obs;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  // var stateId = ''.obs;
  var stateId = ''.obs;
  var companyTypeId = ''.obs;

  var isLoading = false.obs;
  var isUploadLoading = false.obs;
  final RxString uploadingFileKey = ''.obs;

  bool isGstUploadedNow = false;

  final MasterDataController masterData = Get.find();

  var companyTypeList = <CompanyTypeData>[].obs;
  var stateList = <StateData>[].obs;

  @override
  Future<void> onInit() async {
    print("statusCode === : $statusCode");
    _loadGstFromStorage();

    // Initialize Rx lists
    companyTypeList.assignAll(masterData.companyTypes);
    stateList.assignAll(masterData.states);

    // Then watch for changes
    ever(masterData.companyTypes, (_) {
      companyTypeList.assignAll(masterData.companyTypes);
    });

    ever(masterData.states, (_) {
      stateList.assignAll(masterData.states);
    });

    super.onInit();
  }

  StateData? getSelectedState() {
    final id = int.tryParse(stateId.value ?? '0');
    if (id == null || id == 0) return null;

    return stateList.firstWhere(
          (e) => e.stateID == id,
      orElse: () => StateData(stateID: 0, stateName: '', countryID: null),
    );
  }



  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");

    if (gstNumber?.isNotEmpty == true) {
      companyGstController.text = gstNumber!;
    }

    if (statusCode == "300") {            // 300 means partially company details there , 400 - no company details at all
     await fetchCompanyDetail(visitorId);
    }

  }

  // Future<void> pickFile(String type) async {   /// HERE NEED TO IMPLEMENT CODE OPTIMIZE LIKE I DID IN COMPANY PAGE
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'pdf', 'doc'],
  //     allowMultiple: false,
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     String fileName = result.files.single.name;
  //     String filePath = result.files.single.path!;
  //
  //     File pickedFile = File(filePath);
  //     int fileSize = await pickedFile.length();
  //
  //     double sizeInMB = fileSize / (1024 * 1024);
  //     print("File size: ${sizeInMB.toStringAsFixed(2)} MB");
  //
  //     const int maxFileSize = 2 * 1024 * 1024;
  //
  //     if (fileSize > maxFileSize) {
  //       Fluttertoast.showToast(
  //         msg: "File Too Large, Please select a file under 2MB.",
  //       );
  //       return;
  //     }
  //     switch (type) {
  //       case 'gstCopy':
  //         gstCopyFileName.value = fileName;
  //         gstCopyFilePath.value = filePath;
  //         gstCopyError.value = '';
  //         break;
  //     }
  //
  //     try {
  //       isLoading(true);
  //       var response = await ApiBaseService().uploadImage(
  //         pickedFile,
  //         'SQ/FileUpload',
  //         fileCategory: 'gst',
  //         gstNumber: '$gstNumber',
  //         mobileNumber: '$mobileNumber',
  //       );
  //       print("File uploaded successfully: $response");
  //       if(response['status'] == "200"){
  //         isGstUploadedNow = true;
  //         final fileName = response['data']['fileName'];
  //         print("Uploaded file name: $fileName");
  //         gstCopyFileName.value = fileName;
  //       }
  //
  //     } catch (e) {
  //       print("Upload failed: $e");
  //     } finally {
  //       isLoading(false);
  //     }
  //   } else {
  //     print("No file selected.");
  //   }
  // }

  Future<void> pickFile(String fileKey) async {
    await FileUploadHelper.pickAndUploadFile(
      fileType: fileKey,
      gstNumber: gstNumber!,
      mobileNumber: mobileNumber!,
      isUploadLoading: isUploadLoading,
      uploadingKey: uploadingFileKey,
      onSuccess: (uploadedFileName, uploadedFileUrl) {
        switch (fileKey) {
          case 'gstCopy':
            gstCopyFileName.value = uploadedFileName;
            gstCopyFilePath.value = uploadedFileUrl;
            gstCopyError.value = '';
            isGstUploadedNow = true;
            break;
        }
      },
    );
  }

  Future<void> saveOrganization() async {
    if (formKeyOrganization.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }
    if (gstCopyFileName.value.isEmpty) {
      gstCopyError.value = 'Please upload your GST Copy';
      return;
    } else {
      gstCopyError.value = '';
    }

    try {
      isLoading(true);

      var bodyData = {
        "gstN": gstNumber,
        "companyType": companyTypeId.value , // companyTypeController.text,
        "companyName": companyNameController.text,
        "address": communicationAddressController.text,
        "mobileNumber": mobileNumber,
        "city": cityController.text,
        "pincode": pincodeController.text,
        "stateID": stateId.value,
        "district": districtController.text,
        "landline": landlineController.text,
        "gstFileName": gstCopyFileName.value,
        "saveFlag": statusCode == "300" ? 1 : 2,   // 2 insert  -    1 -update - data incompleted
        "gstChangedFlag": statusCode == "400" ? 1 : isGstUploadedNow ? 1 : 0,     // 0 means- no chnage,    1 - update /new    gst new upload - 1, gst repload - 1 , gst no upload just save - 0
      };

      print(jsonEncode(bodyData));

      print("cdddddd $bodyData");
      final Map<String, dynamic> response = await ApiBaseService.request<Map<String, dynamic>>(
        'CompanyDetails/Save',
        body: bodyData,
        method: RequestMethod.POST,
        authenticated: false,
      );

      if(response['status'] == "200"){
        Fluttertoast.showToast(msg: response['message'] ?? "");
        CommonDialog.showConfirmDialog(
          title: "Organization Saved",
          content: "The organization details have been saved successfully.",
          confirmText: "Done",
          cancelTextHide: true,
          leading: Icon(
            Icons.save,
            size: 48,
            color: AppColor.primary,
          ),
          onConfirm: () {
            Get.offAll(() => DashboardScreen());
          },
        );

      }

      //
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }

  }

  // CompanyTypeData get selectedCompanyType =>
  //     companyTypeList.firstWhere(
  //           (e) => e.id == int.tryParse(companyTypeId.value ?? '0'),
  //       orElse: () => CompanyTypeData(id: 0, companyType: ''),
  //     );

  CompanyTypeData? get selectedCompanyType {
    final id = int.tryParse(companyTypeId.value ?? '0');
    if (id == null || id == 0) return null; // ✅ Let it be null to show hint
    return companyTypeList.firstWhere(
          (e) => e.id == id,
      orElse: () => CompanyTypeData(id: 0, companyType: ''),
    );
  }


  Future<void> fetchCompanyDetail(String? visitorId) async {
    try {
      isLoading(true);

      final FetchCompanyDetail response = await ApiBaseService.request<FetchCompanyDetail>(
        'CompanyDetails/FetchCompanyDetail?GSTN=$gstNumber&VisitorID=$visitorId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if(response.status == "200"){
        companyTypeId.value = response.data?.companyType ?? "";
        print("=== companyTypeId ${companyTypeId.value}");
        if (companyTypeId.value.isNotEmpty && companyTypeList.isNotEmpty) {
          final matchedCompany = companyTypeList.firstWhere(
                (type) => type.id.toString() == companyTypeId.value.toString(),
            orElse: () => CompanyTypeData(id: 1, companyType: ''),
          );
          companyTypeController.text = matchedCompany.companyType ?? "";
          print("=== companyTypeId ${companyTypeController.text}");
        }

        companyNameController.text = response.data?.companyName ?? "";
        emailController.text = response.data?.email ?? "";
        communicationAddressController.text = response.data?.address ?? "";
        cityController.text = response.data?.city ?? "";

        stateId.value = response.data?.stateID ?? "";

        print("=== stateId ${stateId.value}");
        if (stateId.value != null && stateList.isNotEmpty) {
          final matchedState = stateList.firstWhere(
                (state) => state.stateID.toString() == stateId.value.toString(),
            orElse: () => StateData(stateID: 1, stateName: ''),
          );
          stateController.text = matchedState.stateName ?? "";
          print("=== stateId ${stateController.text}");
        }

        districtController.text = response.data?.district ?? "";
        pincodeController.text = response.data?.pincode ?? "";
        landlineController.text = response.data?.landline ?? "";
        gstCopyFilePath.value = response.data?.gstFilePath ?? "";
        gstCopyFileName.value = response.data?.gstFileName ?? "";

        print("gstCopyFilePath  $gstCopyFilePath");
        print("gstCopyFileName  $gstCopyFileName");

      }

      print("COMPANY FETCH : ${response.toJson()}");

      // Get.offAll(() => DashboardScreen());
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  // List<StateData> stateList = [];
  // Future<void> stateListApi() async {
  //   print("STATE API");
  //   try {
  //     isLoading(true);
  //
  //     StateList response = await ApiBaseService.request<StateList>(
  //       'SQ/GetStateList',
  //       method: RequestMethod.GET,
  //       authenticated: false
  //     );
  //
  //     if(response.response?.status == "200"){
  //       stateList = response.stateData!;
  //       if(statusCode == "300"){   // 300 means partially company details there , 400 - no company details at all
  //         fetchCompanyDetail(visitorId);
  //       }
  //     }
  //     print("==== ss ${response.stateData}");
  //
  //
  //
  //
  //     print("States: ${stateList.length}");
  //   } catch (e) {
  //     print('Error fetching state list: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  // Future<void> fetchCompanyType() async {
  //   print("STATE API");
  //   try {
  //     isLoading(true);
  //
  //     StateList response = await ApiBaseService.request<StateList>(
  //         'CompanyDetails/FetchCompanyType',
  //         method: RequestMethod.GET,
  //         authenticated: false
  //     );
  //
  //     if(response.response?.status == "200"){
  //       stateList = response.stateData!;
  //       if(statusCode == "300"){   // 300 means partially company details there , 400 - no company details at all
  //         fetchCompanyDetail(visitorId);
  //       }
  //     }
  //     print("==== ss ${response.stateData}");
  //
  //
  //
  //
  //     print("States: ${stateList.length}");
  //   } catch (e) {
  //     print('Error fetching state list: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  //
  // Future<void> fetchCompanyDetail(String? visitorId) async {
  //   try {
  //     isLoading(true);
  //
  //     final FetchCompanyDetail response = await ApiBaseService.request<FetchCompanyDetail>(
  //       'CompanyDetails/FetchCompanyDetail?GSTN=$gstNumber&VisitorID=$visitorId',
  //       method: RequestMethod.GET,
  //       authenticated: false,
  //     );
  //
  //     if(response.status == "200"){
  //       companyTypeController.text = response.data?.companyType ?? "";
  //       companyNameController.text = response.data?.companyName ?? "";
  //       emailController.text = response.data?.email ?? "";
  //       communicationAddressController.text = response.data?.address ?? "";
  //       cityController.text = response.data?.city ?? "";
  //
  //       stateId.value = response.data?.stateID ?? "";
  //
  //       print("=== stateId ${stateId.value}");
  //       if (stateId.value != null && stateList.isNotEmpty) {
  //         final matchedState = stateList.firstWhere(
  //               (state) => state.stateID.toString() == stateId.value.toString(),
  //           orElse: () => StateData(stateID: 1, stateName: ''),
  //         );
  //         stateController.text = matchedState.stateName ?? "";
  //         print("=== stateId ${stateController.text}");
  //       }
  //
  //       districtController.text = response.data?.district ?? "";
  //       pincodeController.text = response.data?.pincode ?? "";
  //       landlineController.text = response.data?.landline ?? "";
  //       gstCopyFilePath.value = response.data?.gstFilePath ?? "";
  //       gstCopyFileName.value = response.data?.gstFileName ?? "";
  //
  //       print("gstCopyFilePath  $gstCopyFilePath");
  //       print("gstCopyFileName  $gstCopyFileName");
  //
  //     }
  //
  //     print("COMPANY FETCH : ${response.toJson()}");
  //
  //     // Get.offAll(() => DashboardScreen());
  //   } catch (e) {
  //     print('Error: $e');
  //     Get.snackbar("Error", "Something went wrong");
  //   } finally {
  //     isLoading(false);
  //   }
  // }


}
