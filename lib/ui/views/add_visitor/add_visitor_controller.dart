import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/helper/file_upload_helper.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/model/tjw/designation_response.dart';
import '../../../core/model/tjw/otp_verify.dart';
import '../../../core/res/colors.dart';
import '../../../services/api_base_service.dart';
import '../../../services/request_method.dart';
import '../../../services/secure_storage_service.dart';

class AddVisitorController extends GetxController {
  final addFormKey = GlobalKey<FormState>();

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

  final TextEditingController businessCardController = TextEditingController();
  final FocusNode businessCardFocusNode = FocusNode();

  final TextEditingController passportPhotoController = TextEditingController();
  final FocusNode passportPhotoFocusNode = FocusNode();

  final TextEditingController idProofController = TextEditingController();
  final FocusNode idProofFocusNode = FocusNode();

  // File paths
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
  var isUploadLoading = false.obs;
  final RxString uploadingFileKey = ''.obs;

  RxBool isPhoneVerified = false.obs;

  bool isIDProofUploadedNow = false;
  bool isBusinessCardUploadedNow = false;
  bool isPhotoUploadedNow = false;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  final getPhoneNumberDB = ''.obs;
  final currentPhoneNumber = ''.obs;

  final MasterDataController masterData = Get.find();
  RxList<DesignationData> designationList = <DesignationData>[].obs;

  @override
  void onInit() {
    print("ADD VISITOR SCREEN");
    super.onInit();
    _loadGstFromStorage();

    // Listen to phone number changes and handle validity + verification
    phoneNumberController.addListener(() {
      currentPhoneNumber.value = phoneNumberController.text;
      isPhoneValid.value = phoneNumberController.text.length == 10;

      // If phone number is modified, mark unverified
      if (phoneNumberController.text != getPhoneNumberDB.value) {
        isPhoneVerified.value = false;
      }
    });

    designationList.assignAll(masterData.designations);

    ever(masterData.designations, (_) {
      designationList.assignAll(masterData.designations);
    });


  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
  }

  Future<void> saveVisitor() async {
    if (addFormKey.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }

    final isValid = validateAllDocuments();
    if (!isValid) {
      return;
    }

    if (!isPhoneVerified.value) {
      Fluttertoast.showToast(
        msg: "Please verify the mobile number before saving.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );

      // toastification.show(
      //   context: context,
      //   title: Text('Hello, world!'),
      //   alignment: Alignment.topCenter,
      //   type: ToastificationType.success,
      //   style: ToastificationStyle.simple,
      //   showProgressBar: true,
      //   autoCloseDuration: const Duration(seconds: 2),
      // );

      return;
    }


    try {
      isLoading(true);

      var bodyData = {
        "visitorID": "0",
        "gstn": gstNumber,
        "visitorPhone": phoneNumberController.text,
        "gender": genderController.text,
        "visitorName": nameController.text,
        "designationID": designationID.value.toLowerCase(),
        "visitorEmailID": emailController.text,
        "idProofType": idTypeController.text,
        "idProofNumber": idNumberController.text,
        "idProofFileName": idProofName.value,
        "idProofURL": "",
        "idProofChangedFlag": isIDProofUploadedNow ? 1 : 0,
        "businessCardFileName": businessFileName.value,
        "businessCardURL": "",
        "businessCardChangedFlag": isBusinessCardUploadedNow ? 1 : 0,
        "visitorPhotoFileName": passportPhotoName.value,
        "visitorPhotoURL": "",
        "visitorPhotoChangedFlag": isPhotoUploadedNow ? 1 : 0,
        "sourceOfRegistration": "",
        "saveFlag": 2, // 2 insert  -    1 -update - data incompleted
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
        Get.back(result: 'refresh');
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
  //   const allowedExtensions = ['jpg', 'pdf'];
  //   const maxFileSizeBytes = 2 * 1024 * 1024; // 2MB
  //
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: allowedExtensions,
  //       allowMultiple: false,
  //     );
  //
  //     if (result == null || result.files.single.path == null) {
  //       print("No file selected.");
  //       return;
  //     }
  //
  //     final file = File(result.files.single.path!);
  //     final fileSize = await file.length();
  //
  //     if (fileSize > maxFileSizeBytes) {
  //       Fluttertoast.showToast(
  //         msg: "File too large. Please select a file under 2MB.",
  //       );
  //       return;
  //     }
  //
  //     final fileName = result.files.single.name;
  //     final filePath = result.files.single.path!;
  //
  //     final fileMappings = {
  //       'businessCard': () {
  //         businessFileName.value = fileName;
  //         // businessFilePath.value = filePath;
  //         businessError.value = '';
  //       },
  //       'photo': () {
  //         passportPhotoName.value = fileName;
  //         // passportPhotoPath.value = filePath;
  //         passportPhotoError.value = '';
  //       },
  //       'idProof': () {
  //         idProofName.value = fileName;
  //         //     idPro ofPath.value = filePath;
  //         idProofError.value = '';
  //       },
  //     };
  //
  //     fileMappings[type]?.call();
  //
  //     uploadingFileKey.value = type;
  //     isUploadLoading(true);
  //
  //     final response = await ApiBaseService().uploadImage(
  //       file,
  //       'SQ/FileUpload',
  //       fileCategory: type,
  //       gstNumber: '$gstNumber',
  //       mobileNumber: phoneNumberController.text,
  //     );
  //
  //     if (response['status'] == "200") {
  //       final uploadedFileName = response['data']['fileName'];
  //       print("Uploaded file name: $uploadedFileName");
  //
  //       Fluttertoast.showToast(msg: response['message'] ?? "");
  //
  //       switch (type) {
  //         case 'businessCard':
  //           businessFileName.value = uploadedFileName;
  //           isBusinessCardUploadedNow = true;
  //           businessFilePath.value = response['data']['url'];
  //           break;
  //         case 'photo':
  //           passportPhotoName.value = uploadedFileName;
  //           isPhotoUploadedNow = true;
  //           passportPhotoPath.value = response['data']['url'];
  //           break;
  //         case 'idProof':
  //           idProofName.value = uploadedFileName;
  //           isIDProofUploadedNow = true;
  //           idProofPath.value = response['data']['url'];
  //           print("idProofPath=== ${idProofPath.value}");
  //           break;
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: "Upload failed. Try again.");
  //     }
  //   } catch (e) {
  //     print("Error during file picking/upload: $e");
  //     Fluttertoast.showToast(msg: "Something went wrong. Try again.");
  //   } finally {
  //     isUploadLoading(false);
  //     uploadingFileKey.value = '';
  //   }
  // }

  Future<void> pickFile(String fileKey) async {
    await FileUploadHelper.pickAndUploadFile(
      fileType: fileKey,
      gstNumber: gstNumber!,
      mobileNumber: phoneNumberController.text,
      isUploadLoading: isUploadLoading,
      uploadingKey: uploadingFileKey,
      onSuccess: (uploadedFileName, uploadedFileUrl) {
        switch (fileKey) {
          case 'businessCard':
            businessFileName.value = uploadedFileName;
            businessFilePath.value = uploadedFileUrl;
            businessError.value = '';
            isBusinessCardUploadedNow = true;
            break;
          case 'photo':
            passportPhotoName.value = uploadedFileName;
            passportPhotoPath.value = uploadedFileUrl;
            passportPhotoError.value = '';
            isPhotoUploadedNow = true;
            break;
          case 'idProof':
            idProofName.value = uploadedFileName;
            idProofPath.value = uploadedFileUrl;
            idProofError.value = '';
            isIDProofUploadedNow = true;
            break;
        }
      },
    );
  }

  // Validation methods
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
                "Please enter otp send to your number : ${phoneNumberController.text}",
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

                isLoading: isOTPVerifyLoading.value,
              );
            }),
          ],
        ),
      ),
    );
  }

  var isOTPLoading = false.obs;
  var optID = ''.obs;

  sendOtp() async {
    try {
      isOTPLoading(true);

      final Map<String, dynamic>
      verifyResponse = await ApiBaseService.request<Map<String, dynamic>>(
        'VisitorDetail/VerifyMobileNumber?mobileNumber=${phoneNumberController.text}',
        method: RequestMethod.GET,
        authenticated: false,
      );
      if (verifyResponse.isNotEmpty) {
        if (verifyResponse['status'] == "100") {
          Fluttertoast.showToast(msg: verifyResponse['message'] ?? "");
          return false;
        } else if (verifyResponse['status'] == "200") {
          optID.value = '';
          Fluttertoast.showToast(msg: verifyResponse['message'] ?? "");
          optID.value = verifyResponse['data']['otpID'].toString();
          return true;
        }
        return false;
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isOTPLoading(false);
    }
  }

  var isOTPVerifyLoading = false.obs;

  Future<void> verifyOtp() async {
    final enteredOTP = otpController.text;

    try {
      isOTPVerifyLoading(true);
      final OtpVerify response = await ApiBaseService.request<OtpVerify>(
        'OTP/OTPVerify?otpID=${optID.value}&mobileNumber=${phoneNumberController.text}&visitorID=${visitorId}&enteredOTP=$enteredOTP',
        method: RequestMethod.GET,
        authenticated: false,
      );

      print("OTP Verify Response: ${response.toJson()}");
      if (response.status == "200") {
        Fluttertoast.showToast(
          msg: response.message ?? "Verified successfully",
        );
        isPhoneVerified.value = true;

        getPhoneNumberDB.value = phoneNumberController.text;
        Get.back();
      } else if (response.status == "100"){
        Fluttertoast.showToast(
          msg: response.message ?? "",
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isOTPVerifyLoading(false);
    }
  }
}
