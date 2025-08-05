import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../core/res/colors.dart';
//
// class CommonFilePickerBox extends StatelessWidget {
//   final String label;
//   final String fileKey;
//   final RxBool isLoading;
//   final void Function(String fileKey) onPick;
//
//   const CommonFilePickerBox({
//     super.key,
//     required this.label,
//     required this.fileKey,
//     required this.isLoading,
//     required this.onPick,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (isLoading.value) return;
//         onPick(fileKey);
//       },
//       child: DottedBorder(
//         options: RectDottedBorderOptions(
//           strokeWidth: 1,
//           color: AppColor.grey.withOpacity(0.6),
//           dashPattern: [3, 6],
//           strokeCap: StrokeCap.square,
//         ),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 30),
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(color: AppColor.white),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset("assets/uploadIcon.png", scale: 3),
//               const SizedBox(width: 20),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//
//               Obx(() => isLoading.value
//                   ? Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//               )
//                   : SizedBox.shrink()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CommonFilePickerBox extends StatelessWidget {
  final String label;
  final String fileKey;
  final RxBool isLoading;
  final RxString uploadingKey;
  final void Function(String fileKey) onPick;

  const CommonFilePickerBox({
    super.key,
    required this.label,
    required this.fileKey,
    required this.isLoading,
    required this.uploadingKey,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading.value) return;
        onPick(fileKey);
      },
      child: DottedBorder(
        options: RectDottedBorderOptions(
          strokeWidth: 1,
          color: AppColor.grey.withOpacity(0.6),
          dashPattern: [3, 6],
          strokeCap: StrokeCap.square,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColor.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/uploadIcon.png", scale: 3),
              const SizedBox(width: 20),
              Obx(() {
                final isUploadingThis =
                    isLoading.value && uploadingKey.value == fileKey;
                return Text(
                  isUploadingThis ? 'Uploading...' : label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),


              Obx(() {
                final loadingThisBox =
                    isLoading.value && uploadingKey.value == fileKey;
                return loadingThisBox
                    ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
