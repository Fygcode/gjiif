import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';
import 'package:tjw1/ui/views/otp/otp_screen.dart';

class SelectPrimaryController extends GetxController{
  var isLoading = false.obs;

  String? gstNumber;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  List<String> extractMobileNumbers(String input) {
    final parts = input.split(RegExp(r'[;,]'));
    final mobileNumbers = parts
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.length == 10 && RegExp(r'^\d{10}$').hasMatch(e))
        .toList();

    return mobileNumbers;
  }

  Future<void> setPrimaryNumber(VisitorPhone data) async {

    String raw = data.visitorPhone;
    List<String> numbers = extractMobileNumbers(raw);

    print("== NNNN ${numbers}"); // Output: [9892375841]

    try {
      isLoading(true);

      final Map<String, dynamic> json = await ApiBaseService.request<Map<String, dynamic>>(
        'OTP/ReSendOTP?mobileNumber=${numbers.first}&visitorID=${data.visitorID}',
        method: RequestMethod.GET,
        authenticated: false,
      );


      if(json.isNotEmpty){

        final otpData = {
          "otpID": json['otpID'],
          "mobileNumber": json['mobileNumber'],
          "visitorID": json['visitorID'],
        };

        print("======= ${otpData}");

        Get.to(() => OtpScreen(isNewPrimaryNumber: true,), arguments: otpData);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }






    // isLoading.value = true;
    //
    // Future.delayed(Duration(seconds: 2), () {
    //   isLoading.value = false;
    //
    //   final dummyOtpData = {
    //     "otpID": 27,
    //     "mobileNumber": "8754509996",
    //     "visitorID": 5608,
    //     "enteredOTP": 0
    //   };
    //
    //   Get.to(() => OtpScreen(), arguments: dummyOtpData);
    // });
  }

}