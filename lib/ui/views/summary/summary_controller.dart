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
  final List<Map<String, dynamic>> entries = [
    {'name': 'Abhinavagupta', 'amount': 1000},
    {'name': 'Bhartrihari', 'amount': 1500},
    {'name': 'Vasugupta', 'amount': 2000},
    {'name': 'Utpaladeva', 'amount': 2500},
  ];

  final Color color1 = Colors.grey.shade100;
  final Color color2 = Colors.grey.shade300;

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
        'VisitorDetail/GetPaymentSummary?EventID=$eventId',
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
    final url = Uri.parse('https://sandbox.cashfree.com/pg/orders');

    final headers = {
      'Content-Type': 'application/json',
      'x-api-version': '2025-01-01',
      'x-client-id': '97644cc98fa0f694b239a7cf344679',
      'x-client-secret': '5461d06075cb72624170d5d0b3684c267e3fb752',
    };

    final body = {
      "order_currency": "INR",
      "order_amount": totalPayableAmount,
      "customer_details": {
        "customer_id": "7112AAA812234",
        "customer_phone": "9898989898",
      }
    };

    print("BODY DATA == ${body}");

    isPaymentLoading.value = true;

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Cashfree Order Created: ${response.body}');

        final data = jsonDecode(response.body);

        final String orderId = data['order_id'] ?? '';
        final String orderToken = data['payment_session_id'] ?? '';

        print('Order ID: $orderId');
        print('Order Token: $orderToken');

        PaymentController().startPayment(
          orderId: orderId,
          orderToken: orderToken,
        );

        return data;
      } else {
        print('❌ Cashfree Order Failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      print('Cashfree order error: $e');
      rethrow;
    } finally {
      isPaymentLoading.value = false;
    }
  }

}
