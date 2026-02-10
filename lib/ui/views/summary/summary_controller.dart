import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tjw1/core/model/tjw/payment_summary_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/ui/views/payment/payment_controller.dart';

import '../../../services/secure_storage_service.dart';

class SummaryController extends GetxController {

  late List<String> visitorIds = [];
  late String eventId = "";

  String joinedVisitorIds = '';

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  @override
  void onInit() {
    super.onInit();

    _loadGstFromStorage();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      visitorIds = List<String>.from(args['visitorList'] ?? []);
      eventId = args['eventId']?.toString() ?? "";

      print("Visitor IDs: $visitorIds");
      print("Event ID: $eventId");

      joinedVisitorIds = visitorIds.join(',');

      print("Joined Visitor IDs: $joinedVisitorIds"); // e.g. "4545,4545,4444"
    } else {
      print("No arguments received in SummaryScreen");
    }

    fetchSummaryScreen();
  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
  }

  var isLoading = false.obs;
  var isPaymentLoading = false.obs;

  EventDetail eventDetail = EventDetail();

  String totalPayableAmount = '';

  final RxList<VisitorSummary> visitorSummaryList = <VisitorSummary>[].obs;

  Future<void> fetchSummaryScreen() async {
    try {
      isLoading(true);
      final response = await ApiBaseService.request<PaymentSummaryResponse>(
        'VisitorDetail/GetPaymentSummary?EventID=$eventId',  // $eventId
        method: RequestMethod.POST,
        authenticated: false,
        body: joinedVisitorIds,
      );

      if (response.status == "200") {
        print(response.paymentSummaryData!.eventDetail);
        eventDetail = response.paymentSummaryData!.eventDetail!;
        visitorSummaryList.assignAll(
          response.paymentSummaryData!.visitorSummary!,
        );
        totalPayableAmount = response.paymentSummaryData!.totalPayment.toString();
      }
    } catch (e) {
      print("Error fetching visitor list: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> createCashfreeOrder() async {
    isPaymentLoading.value = true;

    final body = {
      "eventId": eventId,
      "amount": totalPayableAmount,
      "primaryVisitorId": visitorId.toString(),
      "registeringFor": visitorIds.join(','),
    };

    print("PAYMENT BODY : $body");

    try {
      /// 🔹 CALL BACKEND ONLY ONCE
      final Map<String, dynamic> decoded =
      await ApiBaseService.request<Map<String, dynamic>>(
        'PG/CreateOrder',
        body: body,
        method: RequestMethod.POST,
        authenticated: false,
      );

      final paymentData = decoded['data'];
      if (paymentData == null) {
        throw Exception('Payment data missing in response');
      }

      final String orderId = paymentData['orderID'] ?? '';
      final String orderToken = paymentData['paymentSessionID'] ?? '';

      if (orderId.isEmpty || orderToken.isEmpty) {
        throw Exception('Invalid Cashfree order response');
      }

      print("RESULT DATA : $orderId == $orderToken");

      /// 🔹 USE EXISTING CONTROLLER (VERY IMPORTANT)
      final paymentController = Get.find<PaymentController>();

      paymentController.startPayment(
        orderId: orderId,
        orderToken: orderToken,
      );

      return decoded;
    } catch (e) {
      print('❌ CreateOrder error: $e');
      rethrow;
    } finally {
      isPaymentLoading.value = false;
    }
  }




}
