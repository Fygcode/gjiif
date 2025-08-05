import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.background,
        body: TapOutsideUnFocus(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/splash_background.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, statusBarHeight + 20, 20, 20),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/GJIIF_Logo2.svg", height: 100),
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
                            textCapitalization: TextCapitalization.characters,
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Obx(() {
              return CommonButton(
                text: "Continue",
                isLoading: controller.isLoading.value,
                onPressed: () {
                  if (controller.formKey.currentState?.validate() != true) {
                    print('Form is invalid. Please correct the errors.');
                    return;
                  }
                  controller.gstSubmit();
                },
              );
            }),
          ),
        ),
      ),
    );
  }


}