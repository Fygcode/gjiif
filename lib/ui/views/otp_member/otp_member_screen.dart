import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/common_widget/tap_outside_unfocus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/common_button.dart';
import '../../../core/res/colors.dart';
import 'otp_member_controller.dart';

class OtpMemberScreen extends StatefulWidget {
  const OtpMemberScreen({super.key});

  @override
  State<OtpMemberScreen> createState() => _OtpMemberScreenState();
}

class _OtpMemberScreenState extends State<OtpMemberScreen> {
  final OtpMemberController controller = Get.put(OtpMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "OTP Verification",
          style: TextStyle(color: AppColor.black),
        ),
      ),
      body: TapOutsideUnFocus(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  SvgPicture.asset("assets/message1.svg"),
                  SizedBox(height: 10),
                  Text(
                    "Enter Verification Code",
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "We've sent a 4-digit code to +91 ${controller.mobileNumber}.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.disabled,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Change Number",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verification Code",
                          style: TextStyle(fontSize: 18, color: AppColor.black),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Pinput(
                            length: 4,
                            controller: controller.otpController,
                            focusNode: controller.otpFocusNode,
                            validator: (value) {
                              if (value == null || value.length != 4) {
                                return 'Enter valid 4-digit OTP';
                              }
                              return null; // Valid
                            },
                            errorTextStyle: TextStyle(
                              color: Colors.orangeAccent,
                            ),
                            defaultPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                            ),
                            submittedPinTheme: PinTheme(
                              width: 70,
                              height: 70,
                              textStyle: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (index) => const SizedBox(width: 16),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(height: 40),
                        Obx(() {
                          return CommonButton(
                            text: "Verify OTP",
                            isLoading: controller.isLoading.value,
                            onPressed: () {
                              controller.verifyOtp();
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      controller.resendOtp();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("Resend OTP"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // keeps it compact
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Call us for immediate assistance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff151515),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: "Contact Us",
                      onPressed: () async {
                        final String helplineNumber = "+919935043504";

                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: helplineNumber,
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          print("Could not launch dialer");
                        }
                      },
                      fillColor: const Color(0xff9ABFE4),
                      textColor: const Color(0xff183362),
                      prefixIcon: SvgPicture.asset("assets/call.svg"),
                    ),
                  ),
                  const SizedBox(width: 8), // 👈 should be width, not height
                  Expanded(
                    child: CommonButton(
                      text: "Whatsapp",
                      onPressed: () async {
                        final String phoneNumber = "918056119111";

                        final Uri whatsappUri = Uri.parse(
                          "https://wa.me/$phoneNumber",
                        );

                        if (await canLaunchUrl(whatsappUri)) {
                          await launchUrl(
                            whatsappUri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          print("Could not open WhatsApp");
                        }
                      },
                      fillColor: const Color(0xff9AE4A0),
                      textColor: const Color(0xff0D5F14),
                      prefixIcon: SvgPicture.asset("assets/whatsapp.svg"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
