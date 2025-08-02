// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SelectVisitorController extends GetxController{
//
//   List<bool> selected = List.generate(5, (index) => false); // 5 images
//
//   final TextEditingController filterController = TextEditingController();
//   FocusNode filterFocusNode = FocusNode();
//
//   RxList<bool> checkBoxSelected = <bool>[].obs;
//
//   int get selectedCount => checkBoxSelected.where((e) => e == true).length;
//
//   @override
//   void onInit() {
//     filterController.text = 'All';
//
//     checkBoxSelected.value = List<bool>.filled(selected.length, false);
//
//     super.onInit();
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/registered_visitor_list.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';

import '../../../services/secure_storage_service.dart';

class SelectVisitorController extends GetxController {
  final RxList<bool> selected = List<bool>.filled(5, false).obs;

  int get selectedCount => selected.where((e) => e).length;

  final filterController = TextEditingController(text: 'All');
  final FocusNode filterFocusNode = FocusNode();

  final RxList<VisitorsList> visitorList = <VisitorsList>[].obs;
  final RxList<StatusList> statusList = <StatusList>[].obs;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  final RxString eventId = ''.obs;

  final RxList<String> selectedVisitorIDs = <String>[].obs;

  int dropdownStatusId = -1;


  @override
  void onInit() {
    super.onInit();

    print("SELECT REGISTERED VISITOR");
    _loadGstFromStorage();
    final passedList = Get.arguments?['visitorList'] as List<VisitorsList>?;
    final eventId = Get.arguments?['eventId'].toString();
    final statusDropdownList =
        Get.arguments?['statusList'] as List<StatusList>?;

    if (passedList != null) {
      visitorList.assignAll(passedList);
      selected.assignAll(List<bool>.filled(visitorList.length, false));
    }

    if (eventId != null) {
      print("Received event ID: $eventId");
      this.eventId.value = eventId;
    }

    final StatusList allOption = StatusList(
      statusID: -1,
      status: 'All',
    );

    if (statusDropdownList != null) {
      print("Received status list: $statusDropdownList");
      statusList.assignAll([
        allOption,
        ...statusDropdownList,
      ]);
    }




  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
  }

  Future<bool> isVisitorRegisterWithAllDetail(String visitorId) async {
    try {
      final response = await ApiBaseService.request<Map<String, dynamic>>(
        'VisitorDetail/ValidateVisitor?VisitorId=$visitorId',
        method: RequestMethod.GET,
        authenticated: false,
      );
      final status = response['status']?.toString();
      if (status == "200") {
        print("VISITOR DETAILS COMPLETED");
        return false; // Complete
      } else if (status == "100") {
        return true; // Incomplete
      }
    } catch (e) {
      print('Error in isVisitorRegisterWithAllDetail: $e');
      Get.snackbar("Error", "Something went wrong");
    }

    return true; // fallback to incomplete if unknown
  }


  RxBool isVisitorListLoading = false.obs;

  Future<void> fetchRegisteredVisitorList({bool forceRefresh = false}) async {
    print("dropdownStatusId $dropdownStatusId");
    try {
      isVisitorListLoading.value = true;

      final response = await ApiBaseService.request<RegisteredVisitorResponse>(
        'VisitorDetail/SelectVisitorToRegister?GSTN=$gstNumber&EventId=$eventId&StatusId=$dropdownStatusId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        visitorList.assignAll(response.registeredData?.visitorsList ?? []);
      }
    } catch (e) {
      print("Error fetching visitor list: $e");
    } finally {
      isVisitorListLoading.value = false;
    }
  }

  Future<void> filterVisitorListByStatus(String statusID) async {
    try {
      isVisitorListLoading.value = true;

      final response = await ApiBaseService.request<RegisteredVisitorResponse>(
        'VisitorDetail/SelectVisitorToRegister?GSTN=$gstNumber&EventId=$eventId&StatusId=$statusID',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        visitorList.assignAll(response.registeredData?.visitorsList ?? []);
        print("LETS SEE STATUS LIST = ${statusList.toJson()}");
      }
    } catch (e) {
      print("Error fetching visitor list: $e");
    } finally {
      isVisitorListLoading.value = false;
    }
  }

  Color getStatusColorByID(int statusID) {
    switch (statusID) {
      case 0: // Yet to Register
        return Colors.black87;

      case 1: // Paid - Approval Pending
        return Colors.orangeAccent;

      case 2: // Application Rejected
        return Colors.redAccent;

      case 3: // Application Approved
        return Color(0xff30910e); // Dark Green

      case 4: // Requires Modification
        return Colors.blueGrey;

      case 5: // Complimentary-Approval Pending
        return Colors.deepOrange;

      case 6: // Complimentary-Approved
        return Colors.green;

      case 7: // Complimentary-Rejected
        return Colors.red;

      case 8: // Complimentary-Requires Modification
        return Colors.teal;

      default:
        return Colors.black54; // fallback/default
    }
  }
}
