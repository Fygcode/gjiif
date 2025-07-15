import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';

import '../../../common_widget/common_button.dart';
import '../../../common_widget/common_text_field.dart';
import '../../../common_widget/tap_outside_unfocus.dart';
import '../../../core/res/colors.dart';
import '../phone/phone_screen.dart';
import 'gst_controller.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  final GstController controller = Get.put(GstController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //   height: size.height * 0.7,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/splash_background.png'),
                      // Replace with your image path
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
                        Center(
                          child: SvgPicture.asset("assets/GJIIF_Logo2.svg",height: 100,),
                        ),
                        SizedBox(height: size.height * 0.35),
                        Text(
                          "Enter your GST Number",
                          style: TextStyle(fontSize: 32, color: AppColor.white),
                        ),
                        SizedBox(height: 10),
                        CommonTextField(
                          controller: controller.gstController,
                          focusNode: controller.gstFocusNode,
                          hintText: 'Enter GST Number *',
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          errorTextColor: Colors.white,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter gst number';
                            }
                            RegExp gstRegExp = RegExp(
                              r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                            );
                            if (!gstRegExp.hasMatch(val.toUpperCase())) {
                              return 'Please enter a valid GST number';
                            }
                            return null;
                          },
                        ),
                        // SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Obx(() {
            return CommonButton(
              text: "Continue",
              isLoading: controller.isLoading.value,
              onPressed: () {
                if (controller.gstController.text.isNotEmpty) {
                  controller.gstSubmit();
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
