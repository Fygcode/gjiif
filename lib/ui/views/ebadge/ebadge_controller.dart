import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/registered_badge_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';

class EbadgeController extends GetxController {
  final TextEditingController eventController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    loadGstFromStorage();
    registeredBadgeList();
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
  }

  Future<void> downloadBadge() async {
    try {
      final Map<String, dynamic> json =
          await ApiBaseService.request<Map<String, dynamic>>(
            'VisitorDetail/ViewEBadge?RegistrationID=GF25-TV44455',
            method: RequestMethod.GET,
            authenticated: false,
          );
    } catch (e) {
      print("Error fetching visitor list: $e");
    } finally {}
  }

  RxList<RegisteredVisitorBadgeList> registeredList =
      <RegisteredVisitorBadgeList>[].obs;

  Future<void> registeredBadgeList() async {
    isLoading(true);
    try {
      RegisteredBadgeResponse
      response = await ApiBaseService.request<RegisteredBadgeResponse>(
        'VisitorDetail/GetAllRegisteredVisitorsList?GSTNumber=22AAAAA0000A1Z5&EventID=23',
        method: RequestMethod.POST,
        authenticated: false,
      );

      if (response.status == "200") {
        print("✅ Visitor list fetched successfully.");
        registeredList.assignAll(response.registeredVisitorBadgeList ?? []);
      } else {
        print("❌ Server responded with error status: ${response.status}");
      }
    } catch (e) {
      print("❌ Error fetching visitor list: $e");
    } finally {
      isLoading(false); // ✅ fix: set to false instead of true
    }
  }
}
