// lib/utils/upload_utils.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/helper/file_upload_helper.dart';
class UploadUtils {
  static void showUploadOptions({
    required BuildContext context,
    required String fileType,
    required String gstNumber,
    required String mobileNumber,
    required RxBool isUploadLoading,
    required RxString uploadingKey,
    required void Function(String uploadedFileName, String uploadedFileUrl) onSuccess,
  }) {
    void startUpload(UploadSource source) {
      Navigator.pop(context);
      FileUploadHelper.pickAndUploadFile(
        source: source,
        fileType: fileType,
        gstNumber: gstNumber,
        mobileNumber: mobileNumber,
        onSuccess: onSuccess,
        isUploadLoading: isUploadLoading,
        uploadingKey: uploadingKey,
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                "Select Upload Option",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(height: 1),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.camera_alt,color: AppColor.primary,size: 30,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Take Photo",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
              ),
              onTap: () => startUpload(UploadSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file,color: AppColor.primary,size: 30,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Choose File",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
              ),
              onTap: () => startUpload(UploadSource.file),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );



  }
}
