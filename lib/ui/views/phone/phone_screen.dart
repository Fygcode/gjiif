// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:new_tjw/ui/views/phone/phone_controller.dart';
// import 'package:pinput/pinput.dart';
//
// import '../../../common_widget/common_button.dart';
// import '../../../common_widget/common_text_field.dart';
// import '../../../common_widget/tap_outside_unfocus.dart';
// import '../../../core/res/colors.dart';
//
// class PhoneScreen extends StatefulWidget {
//   const PhoneScreen({super.key});
//
//   @override
//   State<PhoneScreen> createState() => _PhoneScreenState();
// }
//
// class _PhoneScreenState extends State<PhoneScreen> {
//   final PhoneController controller = Get.put(PhoneController());
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColor.background,
//       resizeToAvoidBottomInset: true,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return SafeArea (
//           child: TapOutsideUnFocus(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     //  height: size.height * 0.7,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/splash_background.png'),
//                         // Replace with your image path
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: size.height * 0.4),
//                           Text(
//                             controller.isMobileOptCalled.value
//                                 ? "Enter Your Mobile Number."
//                                 : "Enter Code Sent to your Number",
//                             style: TextStyle(
//                               fontSize: 32,
//                               color: AppColor.white,
//                             ),
//                           ),
//                           !controller.isMobileOptCalled.value
//                               ? Text(
//                                 "We sent it to the number +91 999 39* ***",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColor.white,
//                                 ),
//                               )
//                               : SizedBox.shrink(),
//
//                           SizedBox(height: 10),
//                           controller.isMobileOptCalled.value
//                               ? CommonTextField.phone(
//                                 controller: controller.phoneController,
//                                 focusNode: controller.phoneFocusNode,
//                                 hintText: 'Phone Number *',
//                                 validator: (val) {
//                                   if (val == null || val.isEmpty) {
//                                     return 'Please enter phone number';
//                                   }
//                                   RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
//                                   if (!phoneRegExp.hasMatch(val)) {
//                                     return 'Please enter a valid phone number';
//                                   }
//                                   return null;
//                                 },
//                               )
//                               : Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: Pinput(
//                                   length: 4,
//                                   controller: controller.otpController,
//                                   focusNode: controller.otpFocusNode,
//                                   defaultPinTheme: PinTheme(
//                                     width: 60,
//                                     height:
//                                         60, // Same width and height → square
//                                     textStyle: TextStyle(
//                                       fontSize: 30,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.background,
//                                       // Solid background color
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.white,
//                                         width: 2,
//                                       ),
//                                     ),
//                                   ),
//                                   focusedPinTheme: PinTheme(
//                                     width: 60,
//                                     height: 60,
//                                     textStyle: TextStyle(
//                                       fontSize: 30,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.background,
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                         width: 2,
//                                       ),
//                                     ),
//                                   ),
//                                   submittedPinTheme: PinTheme(
//                                     width: 60,
//                                     height: 60,
//                                     textStyle: TextStyle(
//                                       fontSize: 25,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.background,
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.white60,
//                                         width: 2,
//                                       ),
//                                     ),
//                                   ),
//
//                                   separatorBuilder:
//                                       (index) => const SizedBox(width: 16),
//                                   keyboardType: TextInputType.number,
//                                   onChanged: (value) {
//                                     // Handle input changes here if needed
//                                   },
//                                 ),
//                               ),
//                        //   SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//       bottomNavigationBar: Obx(() {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child:
//               controller.isMobileOptCalled.value
//                   ? CommonButton(
//                     text: "Continue",
//                     onPressed: () {
//                       controller.mobileOpt();
//                     },
//                   )
//                   : Row(
//                     children: [
//                       Expanded(
//                         child: CommonButton(
//                           fillColor: AppColor.secondary,
//                           textColor: AppColor.black,
//                           text: "Resend OTP",
//                           onPressed: () {
//                             controller.mobileOpt();
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: CommonButton(
//                           text: "Continue",
//                           onPressed: () {
//                             controller.mobileOpt();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//         );
//       }),
//     );
//   }
// }

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
      resizeToAvoidBottomInset: false,

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
                    child: Column(
                      children: [
                        Container(
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
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                // Center(
                                //   child: Image.asset(
                                //     "assets/intro_logo.png",
                                //     scale: 2,
                                //   ),
                                // ),
                                Center(child: SvgPicture.asset("assets/GJIIF_Logo2.svg",height: 100,)),
                                SizedBox(height: size.height * 0.3),
                                Text(
                                  "Enter your mobile number",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: AppColor.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CommonTextField.phone(
                                  controller: controller.phoneController,
                                  focusNode: controller.phoneFocusNode,
                                  hintText: 'Phone Number *',
                                  errorTextColor: Colors.orangeAccent,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: CommonButton(text: "Continue", onPressed: controller.mobileOpt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
