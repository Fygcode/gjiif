// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CommonDialog {
//   /// Default Alert Dialog
//   static void showDefaultDialog({
//     required String title,
//     required String content,
//     String confirmText = 'OK',
//     String cancelText = 'Cancel',
//     VoidCallback? onConfirm,
//     VoidCallback? onCancel,
//   }) {
//     Get.defaultDialog(
//       title: title,
//       middleText: content,
//       textConfirm: confirmText,
//       textCancel: cancelText,
//       confirmTextColor: Colors.white,
//       onConfirm: onConfirm,
//       onCancel: onCancel,
//       barrierDismissible: false,
//     );
//   }
//
//   /// Custom Dialog
//   static void showCustomDialog({
//     required Widget content,
//     String? title,
//     bool barrierDismissible = true,
//     double borderRadius = 8.0,
//     Color? backgroundColor,
//   }) {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         backgroundColor: backgroundColor ?? Colors.white,
//         child: content,
//       ),
//       barrierDismissible: barrierDismissible,
//     );
//   }
//
//   /// Bottom Sheet Dialog
//   static void showBottomSheetDialog({
//     required Widget content,
//     bool isDismissible = true,
//     bool enableDrag = true,
//     Color? backgroundColor,
//     double? height,
//   }) {
//     Get.bottomSheet(
//       Container(
//         height: height,
//         decoration: BoxDecoration(
//           color: backgroundColor ?? Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: content,
//       ),
//       isDismissible: isDismissible,
//       enableDrag: enableDrag,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/res/colors.dart';

class CommonDialog {
  /// Custom Confirm Dialog (Reusable)
  static void showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? leading,
  }) {
    showCustomDialog(
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) leading ,
         //   Icon(Icons.warning_amber_rounded, size: 48, color: AppColor.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) onCancel();
                    },
                    child: Text(
                      cancelText,
                      style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondary,
                    ),
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmText,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      borderRadius: 16,
      backgroundColor: Colors.white,
      barrierDismissible: false,
    );
  }

  /// Fully Custom Dialog (Internal use or advanced)
  static void showCustomDialog({
    required Widget content,
    bool barrierDismissible = true,
    double borderRadius = 8.0,
    Color? backgroundColor,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: backgroundColor ?? Colors.white,
        child: content,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Bottom Sheet Dialog
  static void showBottomSheetDialog({
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? height,
  }) {
    Get.bottomSheet(
      Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: content,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }
}
