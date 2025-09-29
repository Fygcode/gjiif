import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/single_otp_verify_response.dart';

class EbadgeMemberController extends GetxController {
  late Data visitorData;

  @override
  void onInit() {
    super.onInit();

    visitorData = Get.arguments as Data;

  }

  void downloadBadge() {}
}
