import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/common_widget/common_button.dart';
import 'package:tjw1/common_widget/tap_outside_unfocus.dart';

import '../../../core/res/colors.dart';
import 'otp_controller.dart';

class OtpScreen extends StatefulWidget {
  bool? isNewPrimaryNumber;
  OtpScreen({super.key, this.isNewPrimaryNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  late final OtpController controller;

  @override
  void initState() {
    controller = Get.put(OtpController(widget.isNewPrimaryNumber));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,

      body: TapOutsideUnFocus(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/splash_background.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 40),
                                Center(
                                  child: SvgPicture.asset(
                                    "assets/GJIIF_Logo2.svg",
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.3),
                                Obx(() {
                                  return Text(
                                    "Enter OTP sent to your number - ${controller.maskedPhone.value}",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: AppColor.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Pinput(
                                    length: 4,
                                    controller: controller.otpController,
                                    focusNode: controller.otpFocusNode,
                                    validator: (value) {
                                      if (value == null ||
                                          value.length != 4) {
                                        return 'Enter valid 4-digit OTP';
                                      }
                                      return null; // Valid
                                    },
                                    errorTextStyle: TextStyle(
                                      color: Colors.orangeAccent,
                                    ),
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
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
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
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
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
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        border: Border.all(
                                          color: Colors.white60,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    separatorBuilder:
                                        (index) => const SizedBox(width: 16),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              Expanded(
                child: CommonButton(
                  fillColor: AppColor.secondary,
                  textColor: AppColor.black,
                  text: "Resend OTP",
                  onPressed: controller.resendOtp,
                  isLoading: controller.isLoading.value,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CommonButton(
                  text: "Continue",
                  onPressed: controller.mobileOpt,
                  isLoading: controller.isLoading.value,
                  isDisabled: controller.isExpiredOrInvalid,
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
