import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/core/model/tjw/designation_response.dart';
import 'package:tjw1/core/model/tjw/visitor_list_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/res/colors.dart';
import '../select_visitor/select_visitor_screen.dart';

class VisitorController extends GetxController {
  // if list is empty means :
  final formKey = GlobalKey<FormState>();

  final TextEditingController genderController = TextEditingController();
  final FocusNode genderFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  final TextEditingController designationController = TextEditingController();
  final FocusNode designationFocusNode = FocusNode();

  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController idTypeController = TextEditingController();
  final FocusNode idTypeFocusNode = FocusNode();

  final TextEditingController idNumberController = TextEditingController();
  final FocusNode idNumberFocusNode = FocusNode();

  // These might be file pickers, not text inputs, but if you use TextFields for filenames or paths:
  final TextEditingController businessCardController = TextEditingController();
  final FocusNode businessCardFocusNode = FocusNode();

  final TextEditingController passportPhotoController = TextEditingController();
  final FocusNode passportPhotoFocusNode = FocusNode();

  final TextEditingController idProofController = TextEditingController();
  final FocusNode idProofFocusNode = FocusNode();

  // File paths
  // String? businessFilePath;
  // String? passportPhotoPath;
  // String? idProofPath;

  var businessFilePath = ''.obs;
  var passportPhotoPath = ''.obs;
  var idProofPath = ''.obs;

  // Reactive file names
  final RxString businessFileName = ''.obs;
  final RxString passportPhotoName = ''.obs;
  final RxString idProofName = ''.obs;

  // Error name
  var businessError = ''.obs;
  var passportPhotoError = ''.obs;
  var idProofError = ''.obs;

  var designationID = ''.obs;

  RxBool isPhoneValid = false.obs;
  var isLoading = false.obs;
  RxBool isPhoneVerified = false.obs;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  Future<void> loadGstFromStorage() async {
    print("------------------");
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
    designationID.value = "0";
    if (designationList.isEmpty) {
      fetchDesignation();
    }
    if (gstNumber?.isNotEmpty == true) {
      await fetchVisitorList();
    }
    phoneNumberController.text = mobileNumber!;
  }

  RxList<DesignationData> designationList = <DesignationData>[].obs;

  Future<void> fetchDesignation() async {
    try {
      isLoading(true);
      DesignationResponse response =
          await ApiBaseService.request<DesignationResponse>(
            'SQ/GetDesignationList',
            method: RequestMethod.GET,
            authenticated: false,
          );
      if (response.response?.status == "200") {
        designationList.assignAll(response.data!);
      }
    } catch (e) {
      print('Error fetching state list: $e');
    } finally {
      isLoading(false);
    }
  }

  var visitorListData = <VisitorListData>[].obs;

  Future<void> fetchVisitorList() async {
    try {
      isLoading(true);

      VisitorListResponse response =
          await ApiBaseService.request<VisitorListResponse>(
            'VisitorDetail/GetAllVisitorsList?GSTN=$gstNumber',
            method: RequestMethod.GET,
            authenticated: false,
          );
      if (response.status == "200") {
        visitorListData.assignAll(response.visitorListData ?? []);

        if (visitorListData.isEmpty) {
          // list is empty means - it is primary member
        }
      }
    } catch (e) {
      print('Error fetching state list: $e');
    } finally {
      isLoading(false);
    }
  }

  /////////////////////////////

  void verifyOtp() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back();
      Fluttertoast.showToast(msg: "Otp Verified Successfully");
      isPhoneVerified.value = true;
    });
  }

  Future<void> saveVisitor() async {
    if (formKey.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }

    final isValid = validateAllDocuments();
    if (!isValid) {
      return;
    }

    try {
      isLoading(true);

      var bodyData = {
        "visitorID": visitorId,
        "gstn": gstNumber,
        "visitorPhone": phoneNumberController.text,
        "gender": genderController.text,
        "visitorName": nameController.text,
        "designationID": designationID.value,
        "visitorEmailID": emailController.text,
        "idProofType": idTypeController.text,
        "idProofNumber": idNumberController.text,
        "idProofFileName": idProofName.value,
        "idProofURL": "",
        "idProofChangedFlag": 1,
        "businessCardFileName": businessFileName.value,
        "businessCardURL": "",
        "businessCardChangedFlag": 1,
        "visitorPhotoFileName": passportPhotoName.value,
        "visitorPhotoURL": "",
        "visitorPhotoChangedFlag": 1,
        "sourceOfRegistration": "",
        "saveFlag": 1,
        // 2 insert  -    1 -update - data incompleted

        // "saveFlag": statusCode == "300" ? 1 : 2,   // 2 insert  -    1 -update - data incompleted
        // "gstChangedFlag": statusCode == "400" ? 1 : isGstUploadedNow ? 1 : 0,     // 0 means- no chnage,    1 - update /new    gst new upload - 1, gst repload - 1 , gst no upload just save - 0
      };

      print(bodyData);

      final Map<String, dynamic> response =
          await ApiBaseService.request<Map<String, dynamic>>(
            'VisitorDetail/Save',
            body: bodyData,
            method: RequestMethod.POST,
            authenticated: false,
          );
      if (response['status'] == "200") {
        Fluttertoast.showToast(msg: "${response['message']}");
        fetchVisitorList();
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }

    // Get.to(() => SelectVisitorScreen());
  }

  void cameraOrGallery(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xffFCF4CB),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 4,
                  width: 45,
                ),
                SizedBox(height: 20),
                Text(
                  "Upload Your Document",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    // Use Expanded here
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          //     pickImage(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: AppColor.secondary),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: AppColor.primary,
                                  size: 40,
                                ),
                                SizedBox(height: 10),
                                const Text(
                                  "From Gallery",
                                  style: TextStyle(fontSize: 17),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          // pickImage(ImageSource.camera);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: AppColor.secondary),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: AppColor.primary,
                                  size: 40,
                                ),
                                SizedBox(height: 10),
                                const Text(
                                  "From Camera",
                                  style: TextStyle(fontSize: 17),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> pickFile(String type) async {
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
  //
  //     switch (type) {
  //       case 'businessCard':
  //         businessFileName.value = fileName;
  //         businessFilePath = filePath;
  //         businessError.value = '';
  //         break;
  //       case 'photo':
  //         passportPhotoName.value = fileName;
  //         passportPhotoPath = filePath;
  //         passportPhotoError.value = '';
  //         break;
  //       case 'idProof':
  //         idProofName.value = fileName;
  //         idProofPath = filePath;
  //         idProofError.value = '';
  //         break;
  //     }
  //     try {
  //       isLoading(true);
  //       var response = await ApiBaseService().uploadImage(
  //         pickedFile,
  //         'SQ/FileUpload',
  //         fileCategory: type,
  //         gstNumber: '$gstNumber',
  //         mobileNumber: '$mobileNumber',
  //       );
  //       if(response['status'] == "200"){
  //         final fileName = response['data'][0]['fileName'];
  //         print("Uploaded file name: $fileName");
  //         if(type == "businessCard"){
  //           businessFileName.value = fileName;
  //         } else if (type == "photo"){
  //           passportPhotoName.value = fileName;
  //         } else {
  //           idProofName.value = fileName;
  //         }
  //
  //       }
  //     } catch (e) {
  //       print("Upload failed: $e");
  //     } finally {
  //       isLoading(false);
  //     }
  //   } else {
  //     print("No file selected.");
  //   }
  // }

  // Validation methods

  Future<void> pickFile(String type) async {
    const allowedExtensions = ['jpg', 'pdf', 'doc'];
    const maxFileSizeBytes = 2 * 1024 * 1024; // 2MB

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        print("No file selected.");
        return;
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();

      if (fileSize > maxFileSizeBytes) {
        Fluttertoast.showToast(
          msg: "File too large. Please select a file under 2MB.",
        );
        return;
      }

      final fileName = result.files.single.name;
      final filePath = result.files.single.path!;

      final fileMappings = {
        'businessCard': () {
          businessFileName.value = fileName;
          // businessFilePath = filePath;
          businessError.value = '';
        },
        'photo': () {
          passportPhotoName.value = fileName;
          // passportPhotoPath = filePath;
          passportPhotoError.value = '';
        },
        'idProof': () {
          idProofName.value = fileName;
          // idProofPath = filePath;
          idProofError.value = '';
        },
      };

      fileMappings[type]?.call();

      isLoading(true);

      final response = await ApiBaseService().uploadImage(
        file,
        'SQ/FileUpload',
        fileCategory: type,
        gstNumber: '$gstNumber',
        mobileNumber: '$mobileNumber',
      );

      if (response['status'] == "200") {
        final uploadedFileName = response['data']['fileName'];
        print("Uploaded file name: $uploadedFileName");

        switch (type) {
          case 'businessCard':
            businessFileName.value = uploadedFileName;
            businessFilePath.value =  response['data']['url'];
            break;
          case 'photo':
            passportPhotoName.value = uploadedFileName;
            passportPhotoPath.value = response['data']['url'];
            break;
          case 'idProof':
            idProofName.value = uploadedFileName;
            idProofPath.value = response['data']['url'];
            break;
        }
      } else {
        Fluttertoast.showToast(msg: "Upload failed. Try again.");
      }
    } catch (e) {
      print("Error during file picking/upload: $e");
      Fluttertoast.showToast(msg: "Something went wrong. Try again.");
    } finally {
      isLoading(false);
    }
  }

  bool validateBusinessCard() {
    if (businessFileName.value.isEmpty) {
      businessError.value = 'Please upload your Business Card';
      return false;
    }
    businessError.value = '';
    return true;
  }

  bool validatePassportPhoto() {
    if (passportPhotoName.value.isEmpty) {
      passportPhotoError.value = 'Please upload your Passport Photo';
      return false;
    }
    passportPhotoError.value = '';
    return true;
  }

  bool validateIdProof() {
    if (idProofName.value.isEmpty) {
      idProofError.value = 'Please upload your ID Proof';
      return false;
    }
    idProofError.value = '';
    return true;
  }

  bool validateAllDocuments() {
    final bcValid = validateBusinessCard();
    final ppValid = validatePassportPhoto();
    final idValid = validateIdProof();
    return bcValid && ppValid && idValid;
  }

  void openDialogBox() {
    return CommonDialog.showCustomDialog(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6),
            Icon(Icons.password, color: AppColor.primary),
            SizedBox(height: 10),
            Text(
              "Enter OTP",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please enter otp send to your number : 9499956224",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            Pinput(
              length: 4,
              controller: otpController,
              focusNode: otpFocusNode,
              defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.secondary, width: 1),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white60, width: 1),
                ),
              ),
              separatorBuilder: (index) => const SizedBox(width: 16),
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
            SizedBox(height: 26),

            Obx(() {
              return CommonButton(
                text: "Verify OTP",
                onPressed: () {
                  final otp = otpController.text.trim();

                  final isValidOtp = RegExp(r'^\d{4}$').hasMatch(otp);

                  if (!isValidOtp) {
                    print("Invalid OTP: must be 4 digits");
                    return;
                  }
                  verifyOtp();
                },

                isLoading: isLoading.value,
              );
            }),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////////////////
}
