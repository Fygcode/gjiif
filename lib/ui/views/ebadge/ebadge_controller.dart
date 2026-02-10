import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tjw1/core/model/tjw/dropdown_api.dart';
import 'package:tjw1/core/model/tjw/registered_badge_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';
import 'package:tjw1/ui/views/pdf_view/pdf_view_screen.dart';

import '../../../common_widget/common_dialog.dart';

class EbadgeController extends GetxController {
  final TextEditingController eventController = TextEditingController();

  var isLoading = false.obs;

  final hasLoadedOnce = false.obs;


  // @override
  // void onInit() {
  //   loadGstFromStorage();
  //   dropdownListApi();
  //   super.onInit();
  // }

  @override
  void onInit() {
    super.onInit();
    print("PROPER CODE");
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading(true);
    try {
      await loadGstFromStorage();     // step 1
      await dropdownListApi();        // step 2 (event id resolved here)

      if (selectedEventId == null) {
        throw Exception("Event ID not available");
      }

      await registeredBadgeList();    // step 3 (safe)
    } catch (e) {
      debugPrint("❌ Bootstrap failed: $e");
    } finally {
      isLoading(false);
    }
  }



  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  String? selectedEventId;

  Future<void> loadGstFromStorage() async {
    print("------------------");
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
    // registeredBadgeList();
  }

  // Future<void> viewBadge(BuildContext context, String? registrationID) async {
  //   Get.to(
  //     () => PdfViewScreen(
  //       pdfUrl:
  //           'https://gjiif.thejewelleryworld.com/VisitorDetail/ViewEBadge?RegistrationID=$registrationID&EventID=$selectedEventId',
  //       registerId: registrationID!,
  //     ),
  //   );
  // }

  Future<void> viewBadge(BuildContext context, String? registrationID) async {
    if (registrationID == null || selectedEventId == null) {
      print("ERROR IN EVENT ID");
      return;
    }

    Get.to(
          () => PdfViewScreen(
        pdfUrl:
        'https://gjiif.thejewelleryworld.com/VisitorDetail/ViewEBadge'
            '?RegistrationID=$registrationID&EventID=$selectedEventId',
        registerId: registrationID,
      ),
    );
  }


  RxList<RegisteredVisitorBadgeList> registeredList =
      <RegisteredVisitorBadgeList>[].obs;

  // Future<void> registeredBadgeList() async {
  //   registeredList.clear();
  //   isLoading(true);
  //   try {
  //     RegisteredBadgeResponse
  //     response = await ApiBaseService.request<RegisteredBadgeResponse>(
  //       'VisitorDetail/GetAllRegisteredVisitorsList?GSTNumber=$gstNumber&EventID=$selectedEventId',
  //       method: RequestMethod.GET,
  //       authenticated: false,
  //     );
  //
  //     if (response.status == "200") {
  //       print("✅ Visitor list fetched successfully.");
  //       registeredList.assignAll(response.registeredVisitorBadgeList ?? []);
  //     } else {
  //       print("❌ Server responded with error");
  //     }
  //   } catch (e) {
  //     print("❌ Error fetching visitor list: $e");
  //   } finally {
  //     isLoading(false); // ✅ fix: set to false instead of true
  //   }
  // }

  Future<void> registeredBadgeList() async {
    if (gstNumber == null || selectedEventId == null) {
      debugPrint("⛔ Skipping API: missing GST or EventID");
      return;
    }

    isLoading(true);
    registeredList.clear();
    try {
      final response = await ApiBaseService.request<RegisteredBadgeResponse>(
        'VisitorDetail/GetAllRegisteredVisitorsList'
            '?GSTNumber=$gstNumber&EventID=$selectedEventId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        registeredList.assignAll(
          response.registeredVisitorBadgeList ?? [],
        );
      }
    } catch (e) {
      debugPrint("❌ Error fetching visitors: $e");
    } finally {
      hasLoadedOnce(true);
      isLoading(false);
    }
  }


  List<DropDownData> dropdownList = [];

  // Future<void> dropdownListApi() async {
  //   print("TESTING");
  //   isLoading(true);
  //   try {
  //     DropdownApi response = await ApiBaseService.request<DropdownApi>(
  //       'Event/GetUpcomingEventsList',
  //       method: RequestMethod.GET,
  //       authenticated: false,
  //     );
  //     if (response.status == "200") {
  //      dropdownList = response.data ?? [];
  //      selectedEventId = dropdownList[0].eventID.toString();
  //     }
  //   } catch (e) {
  //     print("❌ Error fetching visitor list: $e");
  //   } finally {
  //     isLoading(false); // ✅ fix: set to false instead of true
  //   }
  // }

  Future<void> dropdownListApi() async {
    try {
      final response = await ApiBaseService.request<DropdownApi>(
        'Event/GetUpcomingEventsList',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200" &&
          response.data != null &&
          response.data!.isNotEmpty) {

        dropdownList = response.data!;
        final firstEvent = dropdownList.first;

        selectedEventId = firstEvent.eventID?.toString();
        eventController.text = firstEvent.eventShortName ?? '';
      }
    } catch (e) {
      debugPrint("❌ Error fetching events: $e");
    }
  }

}
