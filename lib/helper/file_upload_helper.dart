import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/services/api_base_service.dart';

import '../common_widget/common_dialog.dart';


enum UploadSource { file, camera, gallery }

class FileUploadHelper {
  static Future<void> pickAndUploadFile({
    required UploadSource source,
    required String fileType,
    required String gstNumber,
    required String mobileNumber,
    required Function(String uploadedFileName, String uploadedFileUrl) onSuccess,
    required RxBool isUploadLoading,
    required RxString uploadingKey,
  }) async {
    const allowedExtensions = ['jpg', 'pdf'];
    const maxFileSizeBytes = 2 * 1024 * 1024;
    File? file;

    try {
      if (source == UploadSource.file) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedExtensions,
          allowMultiple: false,
        );

        if (result == null || result.files.single.path == null) {
          print("No file selected.");
          return;
        }
        file = File(result.files.single.path!);
      } else {

        final permission = source == UploadSource.camera
            ? Permission.camera
            : Permission.photos;

        final status = await permission.request();

        print("STATUS - ${status}");

        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            CommonDialog.showConfirmDialog(
              title: "Permission required",
              content: "Please enable permission from app settings to continue.",
              confirmText: "Open Settings",
              cancelTextHide: true,
              leading: Icon(
                Icons.camera_enhance_outlined,
                size: 48,
                color: AppColor.primary,
              ),
              onConfirm: () {
                openAppSettings();
              },
              dismissible: true
            );
          } else {
            Fluttertoast.showToast(msg: "Permission denied. Please allow access.");
          }
          return;
        }

        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: source == UploadSource.camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 85,
        );

        if (pickedFile == null) {
          print("No image selected.");
          return;
        }
        file = File(pickedFile.path);
      }

      final fileSize = await file.length();
      if (fileSize > maxFileSizeBytes) {
        Fluttertoast.showToast(msg: "File too large. Please select a file under 2MB.");
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
      print("Error during picking/uploading: $e");
      Fluttertoast.showToast(msg: "Something went wrong. Try again.");
    } finally {
      isUploadLoading(false);
      uploadingKey.value = '';
    }
  }
}
