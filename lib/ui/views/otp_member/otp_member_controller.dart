import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/single_otp_verify_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';

import '../../../core/model/tjw/otp_verify.dart';
import '../ebadge_member/ebadge_member_screen.dart';

class OtpMemberController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final dynamic data = Get.arguments;

  final TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  String otpID = '';
  String mobileNumber = '';
  String visitorID = '';
  String sentOtp = '';

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      otpID = args['otpID']?.toString() ?? '';
      mobileNumber = args['mobileNumber']?.toString() ?? '';
      visitorID = args['visitorID']?.toString() ?? '';

      // Testing Purpose Start
      sentOtp = data['sentOTP'].toString();
      otpController.text = sentOtp;
      // Testing Purpose End
    }

    print("OtpID: $otpID, Mobile: $mobileNumber, VisitorID: $visitorID");
  }

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final enteredOTP = otpController.text;

    try {
      isLoading(true);
      final SingleOtpVerifyResponse
      response = await ApiBaseService.request<SingleOtpVerifyResponse>(
        'Single/OTPVerify?otpID=$otpID&mobileNumber=$mobileNumber&visitorID=$visitorID&enteredOTP=$enteredOTP&eventID=23',
        method: RequestMethod.GET,
        authenticated: false,
      );

      print("OTP Verify Response: ${response.toJson()}");

      if (response.status == "200") {
        Fluttertoast.showToast(
          msg: response.message ?? "Verified successfully",
        );
        Get.to(() => EbadgeMemberScreen(),arguments: response.data);
      } else {
        Fluttertoast.showToast(msg: response.message ?? "Status 100");
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendOtp() async {
    otpController.text = '';
    try {
      isLoading(true);

      Map<String, dynamic>
      response = await ApiBaseService.request<Map<String, dynamic>>(
        'Single/ReSendOTP?mobileNumber=$mobileNumber&visitorID=$visitorID',
        method: RequestMethod.GET,
        authenticated: false,
      );
      otpID = response['otpID'].toString();
      visitorID = response['visitorID'].toString();
      mobileNumber = response['mobileNumber'].toString();

      // Testing Purpose Start
      sentOtp = response['sentOTP'].toString();
      otpController.text = sentOtp;
      // Testing Purpose End

      Fluttertoast.showToast(msg: "OTP resent successfully");
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
