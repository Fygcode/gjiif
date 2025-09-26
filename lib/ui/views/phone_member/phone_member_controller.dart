import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PhoneMemberController extends GetxController{
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();


  final formSignUp = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void submit() {
    if (formSignUp.currentState?.validate() != true) {
      print('Form is invalid. Please correct the errors.');
      return;
    }
  }

}