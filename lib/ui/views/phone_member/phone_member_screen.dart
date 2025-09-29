import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tjw1/common_widget/common_text_field.dart';
import 'package:tjw1/common_widget/tap_outside_unfocus.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/ui/views/phone_member/phone_member_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/common_button.dart';

class PhoneMemberScreen extends StatefulWidget {
  const PhoneMemberScreen({super.key});

  @override
  State<PhoneMemberScreen> createState() => _PhoneMemberScreenState();
}

class _PhoneMemberScreenState extends State<PhoneMemberScreen> {
  final PhoneMemberController controller = Get.put(PhoneMemberController());

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
          "Phone Verification",
          style: TextStyle(color: AppColor.black),
        ),
      ),
      body: TapOutsideUnFocus(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formSignUp,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  SvgPicture.asset("assets/phone.svg"),
                  SizedBox(height: 10),
                  Text("Verify Your Phone", style: TextStyle(fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "We'll send you a verification code to confirm your phone number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.disabled,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50),
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
                          "Phone Number",
                          style: TextStyle(fontSize: 18, color: AppColor.black),
                        ),
                        SizedBox(height: 12),
                        CommonTextField.phone(
                          controller: controller.phoneController,
                          focusNode: controller.phoneFocusNode,
                          hintText: 'Enter phone number',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter phone number';
                            }
                            RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
                            if (!phoneRegExp.hasMatch(val)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        Obx(() {
                          return CommonButton(
                            text: "Send Verification Code",
                            onPressed: () {
                              controller.submit();
                            },
                            isLoading: controller.isLoading.value,
                            prefixIcon: SvgPicture.asset(
                              "assets/message.svg",
                              color: Colors.white,
                            ),
                          );
                        }),
                      ],
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
