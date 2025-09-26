import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OtpMemberController extends GetxController{

  final formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

}