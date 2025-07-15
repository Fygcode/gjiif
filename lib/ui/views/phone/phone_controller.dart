import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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

  void mobileOpt() {
    final dummyOtpData = {
      "otpID": 27,
      "mobileNumber": "8754509996",
      "visitorID": 5608,
      "enteredOTP": 0
    };

    Get.to(() => OtpScreen(), arguments: dummyOtpData);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
