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

  @override
  void onInit() {
    print("DATA: $data");
    String phone = data['mobileNumber'].toString();
    print("Phone: $phone");
    maskedPhone.value = phone.replaceRange(2, 6, "xxxxxx");

    otpID = data['otpID'].toString();
    mobileNumber = data['mobileNumber'].toString();
    visitorID = data['visitorID'].toString();

    super.onInit();
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
        '/OTPVerify?otpID=$otpID&mobileNumber=$mobileNumber&visitorID=$visitorID&enteredOTP=$enteredOTP',
        method: RequestMethod.GET,
        authenticated: false,
      );

      print("OTP Verify Response: ${response.toJson()}");

      if (response.status == "200") {
        Fluttertoast.showToast(
          msg: response.message ?? "Verified successfully",
        );
        await SecureStorageService().write("mobileNumber", mobileNumber);
      }

      if (response.data?.isCompanyDetailFull == true) {
        Get.offAll(() => OrganizationDetailScreen());
      } else {
        Get.offAll(() => DashboardScreen());
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendOtp() async {
    // if (!_canResend) return;
    //
    // _canResend = false;
    // Fluttertoast.showToast(msg: "OTP resent successfully");
    //
    // Future.delayed(Duration(seconds: 30), () {
    //   _canResend = true;
    // });

    try {
      isLoading(true);

      await ApiBaseService.request<OtpVerify>(
        '/ResendOTP?otpID=$otpID&mobileNumber=$mobileNumber&visitorID=$visitorID&enteredOTP=1011',
        method: RequestMethod.GET,
        authenticated: false,
      );
      Fluttertoast.showToast(msg: "OTP resent successfully");
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
