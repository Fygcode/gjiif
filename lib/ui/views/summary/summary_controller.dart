import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/payment_summary_response.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';

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

  @override
  void onInit() {
    super.onInit();

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

  var isLoading = false.obs;

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
}
