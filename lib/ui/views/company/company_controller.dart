import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/core/model/tjw/fetch_company_detail.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';

class CompanyController extends GetxController {
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

  final TextEditingController stateController = TextEditingController();
  final FocusNode stateFocusNode = FocusNode();

  final TextEditingController pincodeController = TextEditingController();
  final FocusNode pincodeFocusNode = FocusNode();

  final TextEditingController districtController = TextEditingController();
  final FocusNode districtFocusNode = FocusNode();

  final TextEditingController landlineController = TextEditingController();
  final FocusNode landlineFocusNode = FocusNode();

  final TextEditingController uploadGstController = TextEditingController();
  final FocusNode uploadGstFocusNode = FocusNode();

  final formKeyCompany = GlobalKey<FormState>();

  var gstCopyFilePath = ''.obs;

  // Reactive file names
  final RxString gstCopyFileName = ''.obs;

  // Error name
  var gstCopyError = ''.obs;

  var isLoading = false.obs;

  String? gstNumber;
  String? mobileNumber;

  String? visitorId;

  var stateId = ''.obs;
  var companyTypeId = ''.obs;

  bool isGstUploadedNow = false;

  final MasterDataController masterData = Get.find();

  var companyTypeList = <CompanyTypeData>[].obs;
  var stateList = <StateData>[].obs;

  @override
  void onInit() {
    print("GHGHG");
    // TODO: implement onInit
    loadGstFromStorage();
    print("Muthu");

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

  Future<void> loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");

    if (gstNumber?.isNotEmpty == true) {
      companyGstController.text = gstNumber!;
    }
    await fetchCompanyDetail(visitorId);
  }

  Future<void> pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      String fileName = result.files.single.name;
      String filePath = result.files.single.path!;

      File pickedFile = File(filePath);
      int fileSize = await pickedFile.length();

      double sizeInMB = fileSize / (1024 * 1024);
      print("File size: ${sizeInMB.toStringAsFixed(2)} MB");

      const int maxFileSize = 2 * 1024 * 1024;

      if (fileSize > maxFileSize) {
        Fluttertoast.showToast(
          msg: "File Too Large, Please select a file under 2MB.",
        );
        return;
      }
      switch (type) {
        case 'gstCopy':
          gstCopyFileName.value = fileName;
          gstCopyFilePath.value = filePath;
          gstCopyError.value = '';
          break;
      }

      try {
        isLoading(true);
        var response = await ApiBaseService().uploadImage(
          pickedFile,
          'SQ/FileUpload',
          fileCategory: 'gst',
          gstNumber: '$gstNumber',
          mobileNumber: '$mobileNumber',
        );
        if (response['status'] == "200") {
          isGstUploadedNow = true;
          final fileName = response['data']['fileName'];
          print("Uploaded file name: $fileName");
          gstCopyFileName.value = fileName;
          gstCopyFilePath.value = response['data']['url'];
        }
      } catch (e) {
        print("Upload failed: $e");
      } finally {
        isLoading(false);
      }
    } else {
      print("No file selected.");
    }
  }

  Future<void> saveCompany() async {
    if (formKeyCompany.currentState?.validate() != true) {
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
        "companyType": companyTypeId.value,
        "companyName": companyNameController.text,
        "address": communicationAddressController.text,
        "mobileNumber": mobileNumber,
        "city": cityController.text,
        "pincode": pincodeController.text,
        "stateID": stateId.value,
        "district": districtController.text,
        "landline": landlineController.text,
        "gstFileName": gstCopyFileName.value,
        "saveFlag": 1, // 2 insert  -    1 -update - data incompleted
        "gstChangedFlag": isGstUploadedNow ? 1 : 0,
        // 0 means- no chnage,    1 - update /new    gst new upload - 1, gst repload - 1 , gst no upload just save - 0
      };

      print("cdddddd $bodyData");
      final Map<String, dynamic> response =
          await ApiBaseService.request<Map<String, dynamic>>(
            'CompanyDetails/Save',
            body: bodyData,
            method: RequestMethod.POST,
            authenticated: false,
          );

      if (response['status'] == "200") {
        Fluttertoast.showToast(msg: response['message'] ?? "");
      }

      //
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  CompanyTypeData get selectedCompanyType => companyTypeList.firstWhere(
    (e) => e.id == int.tryParse(companyTypeId.value ?? '0'),
    orElse: () => CompanyTypeData(id: 0, companyType: ''),
  );

  Future<void> fetchCompanyDetail(String? visitorId) async {
    try {
      isLoading(true);

      final FetchCompanyDetail
      response = await ApiBaseService.request<FetchCompanyDetail>(
        'CompanyDetails/FetchCompanyDetail?GSTN=$gstNumber&VisitorID=$visitorId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        companyTypeId.value = response.data?.companyType ?? "";
        if (companyTypeId.value.isNotEmpty && companyTypeList.isNotEmpty) {
          final matchedCompany = companyTypeList.firstWhere(
            (type) => type.id.toString() == companyTypeId.value.toString(),
            orElse: () => CompanyTypeData(id: 1, companyType: ''),
          );
          companyTypeController.text = matchedCompany.companyType ?? "";
        }

        companyNameController.text = response.data?.companyName ?? "";
        emailController.text = response.data?.email ?? "";
        communicationAddressController.text = response.data?.address ?? "";
        cityController.text = response.data?.city ?? "";

        stateId.value = response.data?.stateID ?? "";

        if (stateId.value != null && stateList.isNotEmpty) {
          final matchedState = stateList.firstWhere(
            (state) => state.stateID.toString() == stateId.value.toString(),
            orElse: () => StateData(stateID: 1, stateName: ''),
          );
          stateController.text = matchedState.stateName ?? "";
        }

        districtController.text = response.data?.district ?? "";
        pincodeController.text = response.data?.pincode ?? "";
        landlineController.text = response.data?.landline ?? "";
        gstCopyFilePath.value = response.data?.gstFilePath ?? "";
        gstCopyFileName.value = response.data?.gstFileName ?? "";
        print("gstCopyFilePath === ${gstCopyFilePath.value}");
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
