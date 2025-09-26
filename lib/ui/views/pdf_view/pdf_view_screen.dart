
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:toastification/toastification.dart';
//
// import '../../../common_widget/common_dialog.dart';
// import '../../../core/res/colors.dart';
//
// class PdfViewScreen extends StatefulWidget {
//   final String pdfUrl;
//
//   const PdfViewScreen({super.key, required this.pdfUrl});
//
//   @override
//   State<PdfViewScreen> createState() => _PdfViewScreenState();
// }
//
// class _PdfViewScreenState extends State<PdfViewScreen> {
//   bool _isLoading = false; // For overlay on actions (save/share)
//   bool _isPdfLoading = true; // For initial PDF download loading
//   File? _cachedPdfFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _preparePdf();
//   }
//
//   Future<void> _preparePdf() async {
//     setState(() => _isPdfLoading = true);
//     try {
//       final file = await _downloadPdf(widget.pdfUrl);
//       if (file != null) {
//         _cachedPdfFile = file;
//       } else {
//         print("NO permission given");
//         // Optional: Handle null if permission denied on init
//       }
//     } catch (e) {
//       debugPrint('Error downloading PDF: $e');
//     } finally {
//       setState(() => _isPdfLoading = false);
//     }
//   }
//
//   Future<File?> _downloadPdf(String url) async {
//     // Request storage permission (manageExternalStorage for Android 11+)
//     var status = await Permission.manageExternalStorage.request();
//
//     debugPrint("Storage permission status: $status");
//
//     if (!status.isGranted) {
//       if (status.isPermanentlyDenied) {
//         CommonDialog.showConfirmDialog(
//           title: "Permission required",
//           content:
//               "Please enable storage permission from app settings to continue.",
//           confirmText: "Open Settings",
//           cancelTextHide: true,
//           leading: Icon(Icons.folder_open, size: 48, color: AppColor.primary),
//           onConfirm: () async {
//             await openAppSettings();
//           },
//           dismissible: true,
//         );
//       } else {
//         Fluttertoast.showToast(msg: "Permission denied. Please allow access.");
//       }
//       return null;
//     }
//
//     // Download the PDF file
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       // Save to Downloads folder
//       final downloadsDir = Directory('/storage/emulated/0/Download');
//       if (!await downloadsDir.exists()) {
//         await downloadsDir.create(recursive: true);
//       }
//
//       final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
//       final filePath = '${downloadsDir.path}/badge_$timestamp.pdf';
//
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);
//       return file;
//     } else {
//       throw Exception("Failed to download PDF");
//     }
//   }
//
//   void _downloadAndSave() async {
//     setState(() => _isLoading = true);
//     try {
//       // Check storage permission first
//       var status = await Permission.manageExternalStorage.request();
//
//       debugPrint("Storage permission status: $status");
//
//       if (await _checkStoragePermission()) {
//         _preparePdf();
//       } else {
//         toastification.show(
//           context: context,
//           title: Text('Storage permission is required to download the PDF.'),
//           alignment: Alignment.center,
//           type: ToastificationType.error,
//           style: ToastificationStyle.fillColored,
//           backgroundColor: AppColor.white,
//           foregroundColor: AppColor.white,
//           showProgressBar: true,
//           autoCloseDuration: const Duration(seconds: 2),
//         );
//         return;
//       }
//
//       if (_cachedPdfFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("PDF is still loading, please wait.")),
//         );
//         return;
//       }
//
//       // File already downloaded, just show toast/notification
//       toastification.show(
//         context: context,
//         title: Text('PDF saved to ${_cachedPdfFile!.path}'),
//         alignment: Alignment.center,
//         type: ToastificationType.success,
//         style: ToastificationStyle.fillColored,
//         showProgressBar: true,
//         autoCloseDuration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       debugPrint("ERROR - $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _sharePdf() async {
//     setState(() => _isLoading = true);
//     try {
//
//       var status = await Permission.manageExternalStorage.request();
//
//       debugPrint("Storage permission status: $status");
//
//       if (await _checkStoragePermission()) {
//         _preparePdf();
//       } else {
//         toastification.show(
//           context: context,
//           title: Text('Storage permission is required to share the PDF.'),
//           alignment: Alignment.center,
//           type: ToastificationType.error,
//           style: ToastificationStyle.fillColored,
//           backgroundColor: AppColor.white,
//           foregroundColor: AppColor.white,
//           showProgressBar: true,
//           autoCloseDuration: const Duration(seconds: 2),
//         );
//         return;
//       }
//
//       if (_cachedPdfFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("PDF is still loading, please wait.")),
//         );
//         return;
//       }
//
//       final params = ShareParams(
//         text: "My E-Badge",
//         files: [XFile(_cachedPdfFile!.path)],
//       );
//
//       final result = await SharePlus.instance.share(params);
//
//       if (result.status == ShareResultStatus.success) {
//         Fluttertoast.showToast(
//           msg: "Thanks for sharing!",
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } catch (e) {
//       debugPrint("ERROR - $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error sharing: $e")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           appBar: AppBar(
//             title: const Text("E-Badge"),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.download),
//                 onPressed: _downloadAndSave,
//               ),
//               IconButton(icon: const Icon(Icons.share), onPressed: _sharePdf),
//             ],
//           ),
//           body: _buildBody(),
//         ),
//
//         if (_isLoading)
//           Container(
//             color: Colors.black45,
//             child: const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildBody() {
//     if (_isPdfLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_cachedPdfFile != null) {
//       return SfPdfViewer.file(_cachedPdfFile!);
//     } else {
//       return _buildPermissionRequestUI();
//     }
//   }
//
//   Future<bool> _checkStoragePermission() async {
//     final status = await Permission.manageExternalStorage.status;
//     if (status.isGranted) return true;
//
//     return false;
//   }
//
//   Widget _buildPermissionRequestUI() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Storage permission is required to download and open PDFs.\n\n"
//               "Please tap the button below to open app settings and enable 'All files access'.",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.settings),
//               label: const Text("Open App Settings"),
//               onPressed: () async {
//                 //     await openAppSettings();
//                 // Request storage permission (manageExternalStorage for Android 11+)
//                 var status = await Permission.manageExternalStorage.request();
//
//                 debugPrint("Storage permission status: $status");
//
//                 // Optionally, after returning, check permission and try loading again
//                 if (await _checkStoragePermission()) {
//                   _preparePdf();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:toastification/toastification.dart';

import '../../../common_widget/common_dialog.dart';
import '../../../core/res/colors.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String registerId;


  const PdfViewScreen({super.key, required this.pdfUrl, required this.registerId});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  bool _isLoading = false;
  bool _isPdfLoading = true;
  File? _cachedPdfFile;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  /// Checks and requests storage permission (manageExternalStorage)
  Future<bool> _checkAndRequestPermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) return true;

    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  /// Downloads the PDF file with a timestamped filename to avoid overwriting
  Future<File?> _downloadPdf(String url) async {
    if (!await _checkAndRequestPermission()) {
      CommonDialog.showConfirmDialog(
        title: "Permission required",
        content: "Please enable storage permission from app settings to continue.",
        confirmText: "Open Settings",
        cancelTextHide: true,
        leading: Icon(Icons.folder_open, size: 48, color: AppColor.primary),
        onConfirm: () async {
       //   await openAppSettings();
          if (await _checkAndRequestPermission()) {
            _preparePdf();
          }
        },
        dismissible: true,
      );
      return null;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Failed to download PDF");
    }

    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${downloadsDir.path}/badge_${widget.registerId}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  /// Downloads PDF and updates cached file & UI state
  Future<void> _preparePdf() async {
    setState(() => _isPdfLoading = true);
    try {
      final file = await _downloadPdf(widget.pdfUrl);
      if (file != null) {
        setState(() => _cachedPdfFile = file);
      } else {
        debugPrint("PDF download cancelled or permission denied");
      }
    } catch (e) {
      debugPrint("Error downloading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: $e")),
      );
    } finally {
      setState(() => _isPdfLoading = false);
    }
  }

  /// Handles PDF download on button tap
  void _downloadAndSave() async {
    setState(() => _isLoading = true);
    print("NOT YET");
    try {
      final file = await _downloadPdf(widget.pdfUrl);
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Download cancelled or permission denied.")),
        );
        return;
      }

      setState(() => _cachedPdfFile = file);

      toastification.show(
        context: context,
        title: Text('PDF saved to ${file.path}'),
        alignment: Alignment.center,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        showProgressBar: true,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint("Download error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shares the cached PDF file after ensuring it exists and permission is granted
  void _sharePdf() async {
    setState(() => _isLoading = true);
    try {

      if (!await _checkAndRequestPermission()) {
        CommonDialog.showConfirmDialog(
          title: "Permission required",
          content: "Please enable storage permission from app settings to continue.",
          confirmText: "Open Settings",
          cancelTextHide: true,
          leading: Icon(Icons.folder_open, size: 48, color: AppColor.primary),
          onConfirm: () async {
            //   await openAppSettings();
            if (await _checkAndRequestPermission()) {
              _preparePdf();
            }
          },
          dismissible: true,
        );
        return null;
      }

      if (_cachedPdfFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF is still loading, please wait.")),
        );
        return;
      }

      if (!await _checkAndRequestPermission()) {
        toastification.show(
          context: context,
          title: Text('Storage permission is required to share the PDF.'),
          alignment: Alignment.center,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          showProgressBar: true,
          autoCloseDuration: const Duration(seconds: 2),
        );
        return;
      }

      final params = ShareParams(
        text: "My E-Badge",
        files: [XFile(_cachedPdfFile!.path)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        Fluttertoast.showToast(
          msg: "Thanks for sharing!",
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      debugPrint("Share error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sharing PDF: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// UI shown when PDF can't be loaded (likely due to missing permission)
  Widget _buildPermissionRequestUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Storage permission is required to download and open PDFs.\n\n"
                  "Please tap the button below to open app settings and enable 'All files access'.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text("Open App Settings"),
              onPressed: () async {
             //   await openAppSettings();
                if (await _checkAndRequestPermission()) {
                  _preparePdf();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isPdfLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_cachedPdfFile != null) {
      return SfPdfViewer.file(_cachedPdfFile!);
    } else {
      return _buildPermissionRequestUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("E-Badge"),
            actions: [
              IconButton(icon: const Icon(Icons.download), onPressed: _downloadAndSave),
              IconButton(icon: const Icon(Icons.share), onPressed: _sharePdf),
            ],
          ),
          body: _buildBody(),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
