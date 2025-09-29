import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/ui/views/otp_member/otp_member_screen.dart';

import '../../../services/api_base_service.dart';

class PhoneMemberController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  final formSignUp = GlobalKey<FormState>();

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> submit() async {
    if (formSignUp.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }

    isLoading(true);
    try {
      final Map<String, dynamic> response =
      await ApiBaseService.request<Map<String, dynamic>>(
        'Single/VerifyMobileNumber?mobileNumber=8754509996&eventID=23',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response['status'] == "200") {
        Fluttertoast.showToast(msg: response['message'] ?? "");

        final data = response['data'] as Map<String, dynamic>?;

        if (data != null) {
          final otpData = {
            "otpID": data['otpID'],
            "mobileNumber": data['mobileNumber'],
            "visitorID": data['visitorID'],
            "sentOTP": data['sentOTP'],
          };

          Get.to(() => OtpMemberScreen(), arguments: otpData);
        }
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      print('Error fetching event detail: $e');
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading(false);
    }
  }

}
