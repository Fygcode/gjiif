import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/core/model/tjw/designation_response.dart';
import 'package:tjw1/helper/file_upload_helper.dart';
import 'package:tjw1/helper/utils/upload_utils.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:toastification/toastification.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_dialog.dart';
import '../../../core/model/tjw/otp_verify.dart';
import '../../../core/res/colors.dart';
import '../../../services/secure_storage_service.dart';

class EditVisitorController extends GetxController {
  final editFormKey = GlobalKey<FormState>();

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

  int currentVisitorId = 0;


  final MasterDataController masterData = Get.find();
  RxList<DesignationData> designationList = <DesignationData>[].obs;

  final ScrollController scrollController = ScrollController();
  final RxBool showSaveButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGstFromStorage();

    scrollController.addListener(_scrollListener);

    designationList.assignAll(masterData.designations);
    ever(masterData.designations, (_) {
      designationList.assignAll(masterData.designations);
    });

    final args = Get.arguments as Map<String, dynamic>;
    currentVisitorId = args['visitorID'];
    fetchVisitorDetails(currentVisitorId);

    // Listen to phone number changes and handle validity + verification
    phoneNumberController.addListener(() {
      currentPhoneNumber.value = phoneNumberController.text;
      isPhoneValid.value = phoneNumberController.text.length == 10;

      // If phone number is modified, mark unverified
      if (phoneNumberController.text != getPhoneNumberDB.value) {
        isPhoneVerified.value = false;
      }
    });
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    final buffer = 100.0; // Adjust buffer range as needed
    final shouldShow = currentScroll >= (maxScroll - buffer);

    if (showSaveButton.value != shouldShow) {
      showSaveButton.value = shouldShow;
    }
  }

  final RxString gender = ''.obs;
  final RxString idType = ''.obs;

  Future<void> fetchVisitorDetails(int currentVisitorId) async {
    try {
      isLoading(true);
      final Map<String, dynamic> response =
          await ApiBaseService.request<Map<String, dynamic>>(
            'VisitorDetail/GetVisitorDetail?visitorId=$currentVisitorId',
            method: RequestMethod.GET,
            authenticated: false,
          );
      if (response['status'] == "200") {
        genderController.text =
            response['data']['gender'].toString().toLowerCase();

        gender.value = response['data']['gender'].toString().toLowerCase();

        nameController.text = response['data']['visitorName'];

        // designationID.value =
        //     response['data']['designationID'].toString() ?? "";
        //
        // print("=== designationID ${designationID.value}");
        // if (designationID.value != null && designationList.isNotEmpty) {
        //   final matchedState = designationList.firstWhere(
        //     (state) =>
        //         state.designationID.toString() ==
        //         designationID.value.toString(),
        //     orElse: () => DesignationData(designationID: 1, designation: ''),
        //   );
        //   designationController.text = matchedState.designation ?? "";
        // }

        // Step 1: Null-safe assignment
        final rawID = response['data']['designationID'];
        designationID.value = rawID != null ? rawID.toString() : "";

        // Step 2: Safe match and assign
        print("=== designationID ${designationID.value}");
        if (designationID.value.isNotEmpty && designationList.isNotEmpty) {
          final matchedState = designationList.firstWhere(
            (state) => state.designationID.toString() == designationID.value,
            orElse: () => DesignationData(designationID: 0, designation: ''),
          );
          designationController.text = matchedState.designation ?? "";
        }

        phoneNumberController.text = response['data']['visitorPhone'];
        getPhoneNumberDB.value = response['data']['visitorPhone'];
        isPhoneVerified.value = true;

        emailController.text = response['data']['visitorEmailID'];

        idTypeController.text = response['data']['idProofType'];
        idType.value = response['data']['idProofType'];

        idNumberController.text = response['data']['idProofNumber'];

        businessFileName.value = response['data']['businessCardFileName'] ?? "";
        businessFilePath.value = response['data']['businessCardURL'] ?? "";

        passportPhotoName.value =
            response['data']['visitorPhotoFileName'] ?? "";
        passportPhotoPath.value = response['data']['visitorPhotoURL'] ?? "";
        print("passportPhotoPath === ${passportPhotoPath.value}");

        idProofName.value = response['data']['idProofFileName'] ?? "";
        idProofPath.value = response['data']['idProofURL'] ?? "";
      }
    } catch (e) {
      print('Error fetching state list: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
  }

  Future<void> saveUpdatedVisitor(BuildContext context) async {
    if (editFormKey.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }

    final isValid = validateAllDocuments();
    if (!isValid) return;

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
        "visitorID": currentVisitorId,
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
        "saveFlag": 1,
        // 2 insert  -    1 -update - data incompleted

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
        Get.back(result: 'refresh');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }

  }

  void handleFileUpload(BuildContext context, String fileKey) {
    print("FileKey received: $fileKey");
    final onSuccess = getUploadHandler(fileKey);

    if (onSuccess != null) {
      UploadUtils.showUploadOptions(
        context: context,
        fileType: fileKey,
        gstNumber: gstNumber!,
        mobileNumber: phoneNumberController.text,
        isUploadLoading: isUploadLoading,
        uploadingKey: uploadingFileKey,
        onSuccess: onSuccess,
      );
    }
  }

  Function(String, String)? getUploadHandler(String fileKey) {
    switch (fileKey) {
      case 'businessCard':
        return (fileName, fileUrl) {
          businessFileName.value = fileName;
          businessFilePath.value = fileUrl;
          businessError.value = '';
          isBusinessCardUploadedNow = true;
        };
      case 'photo':
        return (fileName, fileUrl) {
          passportPhotoName.value = fileName;
          passportPhotoPath.value = fileUrl;
          passportPhotoError.value = '';
          isPhotoUploadedNow = true;
        };
      case 'idProof':
        return (fileName, fileUrl) {
          idProofName.value = fileName;
          idProofPath.value = fileUrl;
          idProofError.value = '';
          isIDProofUploadedNow = true;
        };
      default:
        return null;
    }
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
                  if(isOTPVerifyLoading.value) return;
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
        getPhoneNumberDB.value =
            phoneNumberController.text; // Now set as verified version
        Get.back();
      } else if (response.status == "100"){
        Fluttertoast.showToast(
          msg: response.message ?? "Verified successfully",
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
