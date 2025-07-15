import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';

class SelectPrimaryController extends GetxController{
  var isLoading = false.obs;

  void setPrimaryNumber(VisitorPhone data) {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;

      final dummyOtpData = {
        "otpID": 27,
        "mobileNumber": "8754509996",
        "visitorID": 5608,
        "enteredOTP": 0
      };

      Get.to(() => OtpScreen(), arguments: dummyOtpData);
    });
  }

}