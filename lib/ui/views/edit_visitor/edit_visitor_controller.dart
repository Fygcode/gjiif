import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/controllers/master_data_controller.dart';
import 'package:tjw1/core/model/tjw/designation_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';

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
  RxBool isPhoneVerified = false.obs;

  bool isIDProofUploadedNow = false;
  bool isBusinessCardUploadedNow = false;
  bool isPhotoUploadedNow = false;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  final getPhoneNumberDB = ''.obs;
  final currentPhoneNumber = ''.obs;

  int currentVisitorId =0;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadGstFromStorage();
  //   phoneNumberController.addListener(() {
  //     isPhoneValid.value = phoneNumberController.text.length == 10;
  //     isPhoneVerified.value = true;
  //   });
  //   if (designationList.isEmpty) {
  //     fetchDesignation();
  //   }
  //
  //   final args = Get.arguments as Map<String, dynamic>;
  //   currentVisitorId = args['visitorID'];
  //   print("currentVisitorId $currentVisitorId");
  //   fetchVisitorDetails(currentVisitorId);
  //
  //   phoneNumberController.addListener(() {
  //     currentPhoneNumber.value = phoneNumberController.text;
  //   });
  // }

  final MasterDataController masterData = Get.find();
  RxList<DesignationData> designationList = <DesignationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadGstFromStorage();


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

        designationID.value =
            response['data']['designationID'].toString() ?? "";

        print("=== designationID ${designationID.value}");
        if (designationID.value != null && designationList.isNotEmpty) {
          final matchedState = designationList.firstWhere(
            (state) =>
                state.designationID.toString() ==
                designationID.value.toString(),
            orElse: () => DesignationData(designationID: 1, designation: ''),
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

        passportPhotoName.value = response['data']['visitorPhotoFileName'] ?? "";
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


  Future<void> saveUpdatedVisitor() async {
    if (editFormKey.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }

    final isValid = validateAllDocuments();
    if (!isValid) return;

    if (!isPhoneVerified.value) {
      Fluttertoast.showToast(
        msg: "Please verify the mobile number before saving.",
        gravity: ToastGravity.CENTER,
      );
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
        "saveFlag": 1 ,
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
          // businessFilePath.value = filePath;
          businessError.value = '';
        },
        'photo': () {
          passportPhotoName.value = fileName;
          // passportPhotoPath.value = filePath;
          passportPhotoError.value = '';
        },
        'idProof': () {
          idProofName.value = fileName;
          //     idPro ofPath.value = filePath;
          idProofError.value = '';
        },
      };

      fileMappings[type]?.call();

      isLoading(true);

      print("POPO = ${phoneNumberController.text}");
      final response = await ApiBaseService().uploadImage(
        file,
        'SQ/FileUpload',
        fileCategory: type,
        gstNumber: '$gstNumber',
        mobileNumber: phoneNumberController.text,
      );

      if (response['status'] == "200") {
        final uploadedFileName = response['data']['fileName'];
        print("Uploaded file name: $uploadedFileName");

        switch (type) {
          case 'businessCard':
            businessFileName.value = uploadedFileName;
            isBusinessCardUploadedNow = true;
            businessFilePath.value = response['data']['url'];
            print("BUSINESS CARD");
            break;
          case 'photo':
            passportPhotoName.value = uploadedFileName;
            isPhotoUploadedNow = true;
            passportPhotoPath.value = response['data']['url'];
            print("PHOTO");
            print("PHOTO URL ${passportPhotoPath.value}");
            break;
          case 'idProof':
            idProofName.value = uploadedFileName;
            isIDProofUploadedNow = true;
            idProofPath.value = response['data']['url'];
            print("idProofPath=== ${idProofPath.value}");
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
        Fluttertoast.showToast(msg: response.message ?? "Verified successfully");
        isPhoneVerified.value = true;
        getPhoneNumberDB.value = phoneNumberController.text; // Now set as verified version
        Get.back();
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isOTPVerifyLoading(false);
    }
  }
}
