import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';
import 'package:tjw1/ui/views/phone/phone_screen.dart';

import '../organization/organizationDetail_screen.dart';

class PhoneController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  var isMobileOptCalled = false.obs;
  var isLoading = false.obs;
  bool isAlreadyRegister = false;

  Future<void> mobileOpt() async {
    try {
      isLoading(true);

      final Map<String, dynamic> verifyResponse =
          await ApiBaseService.request<Map<String, dynamic>>(
            'VisitorDetail/VerifyMobileNumber?mobileNumber=${phoneController.text}',
            method: RequestMethod.GET,
            authenticated: false,
          );
      if (verifyResponse.isNotEmpty) {
        if (verifyResponse['status'] == "100") {
          Fluttertoast.showToast(msg: verifyResponse['message'] ?? "");
          isAlreadyRegister = true;
          return;
        } else {
          final Map<String, dynamic> json =
              await ApiBaseService.request<Map<String, dynamic>>(
                'OTP/ReSendOTP?mobileNumber=${phoneController.text}',
                method: RequestMethod.GET,
                authenticated: false,
              );
          if (json.isNotEmpty) {
            final otpData = {
              "otpID": json['otpID'],
              "mobileNumber": json['mobileNumber'],
              "visitorID": json['visitorID'],
            };
            Get.to(() => OtpScreen(), arguments: otpData);
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
