import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tjw1/ui/views/phone/phone_controller.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';

class PhoneScreen extends StatefulWidget {
  bool? isOptScreen;

  PhoneScreen({this.isOptScreen, super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final PhoneController controller = Get.put(PhoneController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: true,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return TapOutsideUnFocus(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 47),
                                  Center(
                                    child: SvgPicture.asset(
                                      "assets/GJIIF_Logo2.svg",
                                      height: 100,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.35),
                                  Text(
                                    "Enter your mobile number",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      color: AppColor.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CommonTextField.phone(
                                    controller: controller.phoneController,
                                    focusNode: controller.phoneFocusNode,
                                    hintText: 'Phone Number *',
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    errorTextColor: Colors.orangeAccent,
                                    onChanged: (val) {
                                      if (val.isNotEmpty) {
                                        RegExp phoneRegExp = RegExp(
                                          r'^[0-9]{10}$',
                                        );
                                        if (phoneRegExp.hasMatch(val)) {
                                          // ✅ Close keyboard once phone is valid
                                          FocusScope.of(
                                            controller.phoneFocusNode.context!,
                                          ).unfocus();
                                        }
                                      }
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Please enter phone number';
                                      }
                                      RegExp phoneRegExp = RegExp(
                                        r'^[0-9]{10}$',
                                      );
                                      if (!phoneRegExp.hasMatch(val)) {
                                        return 'Please enter a valid phone number';
                                      }
                                      return null; // ✅ don’t unfocus here
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          //   controller.isAlreadyRegister ?
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                controller.launchCaller();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child:Text(
                                  "Contact Helpline",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    textBaseline: TextBaseline.alphabetic,
                                  ),
                                  textAlign: TextAlign.end,
                                )

                              ),
                            ),
                          ),
                          //       : SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() {
            return CommonButton(
              text: "Continue",
              onPressed: controller.mobileOpt,
              isLoading: controller.isLoading.value,
            );
          }),
        ),
      ),
    );
  }
}
