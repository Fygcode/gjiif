import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:tjw1/services/api_base_service.dart';

class FileUploadHelper {
  static Future<void> pickAndUploadFile({
    required String fileType,
    required String gstNumber,
    required String mobileNumber,
    required Function(String uploadedFileName, String uploadedFileUrl) onSuccess,
    required RxBool isUploadLoading,
    required RxString uploadingKey,
  }) async {
    const allowedExtensions = ['jpg', 'pdf'];
    const maxFileSizeBytes = 2 * 1024 * 1024;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        print("No file selected.");
        return;
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();

      if (fileSize > maxFileSizeBytes) {
        Fluttertoast.showToast(
          msg: "File too large. Please select a file under 2MB.",
        );
        return;
      }

      isUploadLoading(true);
      uploadingKey.value = fileType;

      final response = await ApiBaseService().uploadImage(
        file,
        'SQ/FileUpload',
        fileCategory: fileType,
        gstNumber: gstNumber,
        mobileNumber: mobileNumber,
      );

      if (response['status'] == "200") {
        final uploadedFileName = response['data']['fileName'];
        final uploadedUrl = response['data']['url'];

        onSuccess(uploadedFileName, uploadedUrl);
        Fluttertoast.showToast(msg: response['message'] ?? "");
      } else {
        Fluttertoast.showToast(msg: "Upload failed. Try again.");
      }
    } catch (e) {
      print("Error during file picking/upload: $e");
      Fluttertoast.showToast(msg: "Something went wrong. Try again.");
    } finally {
      isUploadLoading(false);
      uploadingKey.value = '';
    }
  }
}
