import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';
import 'package:tjw1/ui/views/phone/phone_screen.dart';
import 'package:tjw1/ui/views/selectPrimaryNo/select_primary_screen.dart';

class GstController extends GetxController {
  final TextEditingController gstController = TextEditingController();
  FocusNode gstFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  Future<void> gstSubmit() async {
    await gstApi();
  }

  Future<void> gstApi() async {
    try {
      isLoading(true);

      // Get raw response as a Map
      final Map<String, dynamic> json = await ApiBaseService.request<Map<String, dynamic>>(
        'CompanyDetails/VerifyGSTN?sGSTN=${gstController.text}',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if(json.isNotEmpty){
        final response = SelectPrimaryNumber.fromJson(json);
        final status = response.status;

        print("ALALAL $response");
        print("ALALAL $json");


        await SecureStorageService().write("gst", gstController.text);
   //     await SecureStorageService().write("visitorID", response.data['visitorID'].toString());


        if (status == "100") {
          Get.to(() => PhoneScreen());
          return;
        }
        else if (status == "200") {
          Fluttertoast.showToast(msg: response.message ?? "");
          await SecureStorageService().write("gst", gstController.text);
          await SecureStorageService().write("visitorID", response.data['visitorID'].toString());
          Get.to(() => OtpScreen(), arguments:  response.data,);
          return;
        }
        else if (status == "300") {
          final List<VisitorPhone> phoneList = (response.data as List)
              .map((e) => VisitorPhone.fromJson(e))
              .toList();

          Get.to(() => SelectPrimaryScreen(phoneList));
          return;
        }
        else {
          Get.snackbar("Unexpected", "Unhandled response status: $status");
        }

      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }



}
