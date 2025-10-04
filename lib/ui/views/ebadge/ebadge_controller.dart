import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/core/model/tjw/registered_badge_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';
import 'package:tjw1/ui/views/pdf_view/pdf_view_screen.dart';

import '../../../common_widget/common_dialog.dart';

class EbadgeController extends GetxController {
  final TextEditingController eventController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    loadGstFromStorage();
    super.onInit();
  }

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  Future<void> loadGstFromStorage() async {
    print("------------------");
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");

    registeredBadgeList();
  }

  Future<void> viewBadge(
    BuildContext context,
    String? registrationID,
  ) async {
    Get.to(
      () => PdfViewScreen(
        pdfUrl: 'https://gjiif.thejewelleryworld.com/VisitorDetail/ViewEBadge?RegistrationID=$registrationID&EventID=23',
        registerId : registrationID!,
      ),
    );
  }

  RxList<RegisteredVisitorBadgeList> registeredList =
      <RegisteredVisitorBadgeList>[].obs;

  Future<void> registeredBadgeList() async {
    registeredList.clear();
    isLoading(true);
    try {
      RegisteredBadgeResponse
      response = await ApiBaseService.request<RegisteredBadgeResponse>(
        'VisitorDetail/GetAllRegisteredVisitorsList?GSTNumber=$gstNumber&EventID=23',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        print("✅ Visitor list fetched successfully.");
        registeredList.assignAll(response.registeredVisitorBadgeList ?? []);
      } else {
        print("❌ Server responded with error");
      }
    } catch (e) {
      print("❌ Error fetching visitor list: $e");
    } finally {
      isLoading(false); // ✅ fix: set to false instead of true
    }
  }
}
