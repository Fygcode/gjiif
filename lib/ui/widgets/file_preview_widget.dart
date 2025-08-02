import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/common_widget/common_dialog.dart';

class FilePreviewWidget extends StatelessWidget {
  final RxString filePath;
  final RxString fileName;
  final RxString errorText;
  final RxBool isLoading;

  const FilePreviewWidget({
    Key? key,
    required this.filePath,
    required this.fileName,
    required this.errorText,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Obx(() {
        //   final path = filePath.value;
        //   final name = fileName.value;
        //   if (path.isEmpty || name.isEmpty) return const SizedBox.shrink();
        //
        //   return InkWell(
        //     onTap: () {
        //       if (isLoading.value) {
        //         print("It's loading");
        //         return;
        //       }
        //
        //       print("FILE PATH = $path");
        //       print("FILE NAME = $name");
        //
        //       CommonDialog.showCustomDialog(
        //         content: SizedBox(
        //           width: MediaQuery.of(context).size.width * 0.9,
        //           height: MediaQuery.of(context).size.height * 0.6,
        //           child: Padding(
        //             padding: const EdgeInsets.all(6.0),
        //             child:
        //                 path.toLowerCase().endsWith('.pdf')
        //                     ? path.startsWith("http")
        //                         ? SfPdfViewer.network(path)
        //                         : SfPdfViewer.file(File(path))
        //                     : CachedNetworkImage(
        //                       imageUrl: path,
        //                       fit: BoxFit.contain,
        //                       placeholder:
        //                           (context, url) => const Center(
        //                             child: CircularProgressIndicator(),
        //                           ),
        //                       errorWidget:
        //                           (context, url, error) =>
        //                               const Text('Failed to load image'),
        //                     ),
        //
        //           ),
        //         ),
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: Text(
        //               name,
        //               style: const TextStyle(
        //                 fontSize: 14,
        //                 decoration: TextDecoration.underline,
        //                 color: Colors.blue,
        //               ),
        //             ),
        //           ),
        //           const SizedBox(width: 8),
        //           Image.asset('assets/tick.png', scale: 2, color: Colors.green),
        //         ],
        //       ),
        //     ),
        //   );
        // }),

        Obx(() {
          final path = filePath.value;
          final name = fileName.value;
          if (path.isEmpty || name.isEmpty) return const SizedBox.shrink();

          final isPdf = path.toLowerCase().endsWith('.pdf');
          final isNetwork = path.startsWith("http");

          // Add timestamp only if it's an image URL
          final cacheBypassPath = !isPdf && isNetwork
              ? "$path?ts=${DateTime.now().millisecondsSinceEpoch}"
              : path;

          return InkWell(
            onTap: () {
              if (isLoading.value) {
                print("It's loading");
                return;
              }

              print("FILE PATH = $path");
              print("FILE NAME = $name");

              CommonDialog.showCustomDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: isPdf
                        ? isNetwork
                        ? SfPdfViewer.network(path)
                        : SfPdfViewer.file(File(path))
                        : CachedNetworkImage(
                      imageUrl: cacheBypassPath,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Text('Failed to load image'),
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/tick.png', scale: 2, color: Colors.green),
                ],
              ),
            ),
          );
        }),

        Obx(() {
          final error = errorText.value;
          return error.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}
