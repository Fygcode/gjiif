import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/secure_storage_service.dart';

import '../dashboard/dashboard_screen.dart';

class OrganizationDetailController extends GetxController {
  final TextEditingController companyGstController = TextEditingController();
  final FocusNode companyGstFocusNode = FocusNode();

  final TextEditingController companyTypeController = TextEditingController();
  final FocusNode companyTypeFocusNode = FocusNode();

  final TextEditingController companyNameController = TextEditingController();
  final FocusNode companyNameFocusNode = FocusNode();

  final TextEditingController communicationAddressController =
      TextEditingController();
  final FocusNode communicationAddressFocusNode = FocusNode();

  final TextEditingController cityController = TextEditingController();
  final FocusNode cityFocusNode = FocusNode();

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
  String? gstCopyFilePath;

  // Reactive file names
  final RxString gstCopyFileName = ''.obs;

  String? selectedCompanyType;

  // Error name
  var gstCopyError = ''.obs;

  String? gstNumber;
  String? mobileNumber;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGstFromStorage();
  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    print("Stored token: $gstNumber");
    if (gstNumber?.isNotEmpty == true) {
      companyGstController.text = gstNumber!;
    }
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
          gstCopyFilePath = filePath;
          gstCopyError.value = '';
          break;
      }

      try {
        isLoading(true);
        var response = await ApiBaseService().uploadImage(
          pickedFile,
          '/ImageUpload',
          fileCategory: 'gst',
          gstNumber: '$gstNumber',
          mobileNumber: '$mobileNumber',
        );
        print("File uploaded successfully: $response");
      } catch (e) {
        print("Upload failed: $e");
      } finally {
        isLoading(false);
      }
    } else {
      print("No file selected.");
    }
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
      gstCopyError.value = ''; // Clear error if file is uploaded
    }

    Get.offAll(() => DashboardScreen());
  }
}
