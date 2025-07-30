import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/otp_verify.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';
import 'package:tjw1/ui/views/dashboard/dashboard_screen.dart';
import 'package:tjw1/ui/views/phone/phone_screen.dart';

import '../organization/organizationDetail_screen.dart';

class OtpController extends GetxController {
  final dynamic data = Get.arguments;
  final formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  var isMobileOptCalled = false.obs;
  var isLoading = false.obs;

  var maskedPhone = ''.obs;

  bool _canResend = true;

  String otpID = '';
  String mobileNumber = '';
  String visitorID = '';

  bool isExpiredOrInvalid = false;

  bool? isNewPrimaryNumber;

  String? gstNumber;

  OtpController(this.isNewPrimaryNumber);

  @override
  void onInit() {
    print("DATA: $data");
    String phone = data['mobileNumber'].toString();
    print("Phone: $phone");
    print("isNewPrimaryNumber: $isNewPrimaryNumber");
    maskedPhone.value = phone.replaceRange(2, 6, "xxxxxx");

    otpID = data['otpID'].toString();
    mobileNumber = data['mobileNumber'].toString();
    visitorID = data['visitorID'].toString();

    _loadGstFromStorage();

    super.onInit();
  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
  }

  Future<void> mobileOpt() async {
    print("Tapped MOBILE OTP");

    if (!formKey.currentState!.validate()) {
      return;
    }

    final enteredOTP = otpController.text;

    try {
      isLoading(true);
      final OtpVerify response = await ApiBaseService.request<OtpVerify>(
        'OTP/OTPVerify?otpID=$otpID&mobileNumber=$mobileNumber&visitorID=$visitorID&enteredOTP=$enteredOTP',
        method: RequestMethod.GET,
        authenticated: false,
      );

      print("OTP Verify Response: ${response.toJson()}");

      // 100 error - 200 dashboard - 300 - fetch company details - 400 - no fetch just navigate company detail

      if (response.status == "200") {
        Fluttertoast.showToast(
          msg: response.message ?? "Verified successfully",
        );
        await setPrimaryNumber(isNewPrimaryNumber, status: response.status,visitorID: visitorID);
        await SecureStorageService().write("mobileNumber", mobileNumber);
      } else if (response.status == "100") {
        Fluttertoast.showToast(msg: response.message ?? "Status 100");
        isExpiredOrInvalid = true;
      } else if (response.status == "300" || response.status == "400") {
        print("LET'S CHECK ${response.status}");
        await SecureStorageService().write("mobileNumber", mobileNumber);
        await setPrimaryNumber(isNewPrimaryNumber, status: response.status,visitorID: visitorID);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendOtp() async {
    isExpiredOrInvalid = false;
    otpController.text = '';

    try {
      isLoading(true);

      Map<String, dynamic>
      response = await ApiBaseService.request<Map<String, dynamic>>(
        'OTP/ReSendOTP?otpID=$otpID&mobileNumber=$mobileNumber&visitorID=$visitorID&enteredOTP=1011',
        method: RequestMethod.GET,
        authenticated: false,
      );
      otpID = response['otpID'].toString();
      visitorID = response['visitorID'].toString();
      mobileNumber = response['mobileNumber'].toString();

      Fluttertoast.showToast(msg: "OTP resent successfully");
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  Future<void> setPrimaryNumber(bool? isNewPrimaryNumber, {status, visitorID}) async {
    print("isNewPrimaryNumber $isNewPrimaryNumber");
    print("VisitorID ${visitorID}");

    try {
      isLoading(true);
      final Map<String, dynamic> json = await ApiBaseService.request<Map<String, dynamic>>(
        'VisitorDetail/SetPrimaryMobileNumber?GSTN=$gstNumber&VisitorID=$visitorID',
        method: RequestMethod.GET,
        authenticated: false,
      );
      if (json.isNotEmpty) {
        if (status == "300" || status == "400") {
          Get.offAll(() => OrganizationDetailScreen(), arguments: status);
        } else if (status == "200") {
          Get.offAll(() => DashboardScreen());
        }
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
