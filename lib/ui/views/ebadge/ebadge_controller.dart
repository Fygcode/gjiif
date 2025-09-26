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

  // Future<void> downloadBadge() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://gjiif.thejewelleryworld.com/VisitorDetail/ViewEBadge?RegistrationID=GF25-TV5608&EventID=23'),
  //       headers: {
  //         'Accept': 'application/pdf',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final pdfBytes = response.bodyBytes;
  //       print("PDF BYTES = $pdfBytes");
  //     } else {
  //       print("Failed to fetch PDF. Status: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error downloading badge PDF: $e");
  //   }
  // }
  //
  //
  // Future<void> downloadBadgeStreamed() async {
  //   try {
  //     final request = http.Request(
  //       'GET',
  //       Uri.parse('https://gjiif.thejewelleryworld.com/VisitorDetail/ViewEBadge?RegistrationID=GF25-TV44455'),
  //     );
  //
  //     request.headers['Accept'] = 'application/pdf';
  //
  //     final response = await request.send(); // This returns a StreamedResponse
  //
  //     if (response.statusCode == 200) {
  //       // Get device's temporary directory
  //       final dir = await getTemporaryDirectory();
  //       final filePath = '${dir.path}/badge.pdf';
  //       final file = File(filePath);
  //
  //       // Open file for writing and pipe the stream into it
  //       final fileSink = file.openWrite();
  //       await response.stream.pipe(fileSink);
  //       await fileSink.close();
  //
  //       print("PDF saved at: $filePath");
  //
  //       // You can now open it in a PDF viewer package if you want
  //       // OpenFile.open(filePath);
  //
  //     } else {
  //       print("Failed to fetch PDF. Status: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error streaming badge PDF: $e");
  //   }
  // }

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
