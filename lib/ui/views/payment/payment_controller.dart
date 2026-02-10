
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final CFPaymentGatewayService _pgService = CFPaymentGatewayService();

  final RxString paymentStatus = ''.obs;
  bool _isPaymentInProgress = false;


  /// Change this based on build flavor
  static const CFEnvironment _environment = CFEnvironment.SANDBOX;

  @override
  void onInit() {
    super.onInit();
    _initCallbacks();
  }

  /// Initialize callbacks ONCE
  void _initCallbacks() {
    _pgService.setCallback(
      _onPaymentSuccess,
      _onPaymentFailure,
    );
  }

  /// Start payment
  void startPayment({
    required String orderId,
    required String orderToken,
  }) {
    if (_isPaymentInProgress) {
      debugPrint('⚠️ Payment already in progress');
      return;
    }

    _isPaymentInProgress = true;

    try {
      final session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId)
          .setPaymentSessionId(orderToken)
          .build();

      final payment = CFDropCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      _pgService.doPayment(payment);
    } on CFException catch (e) {
      _isPaymentInProgress = false;
      debugPrint('❌ CFException: ${e.message}');
      rethrow;
    }
  }


  /// Success handler
  void _onPaymentSuccess(String orderId) {
    paymentStatus.value = 'SUCCESS';
    _isPaymentInProgress = false;

    debugPrint('✅ Payment Successful: $orderId');

    Fluttertoast.showToast(
      msg: "Payment Successful",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    Get.offAllNamed('/dashboard');
  }

  /// Failure handler

  /// FAILURE CALLBACK (matches SDK exactly)
  void _onPaymentFailure(CFErrorResponse error, String orderId) {
    paymentStatus.value = 'FAILED';
    _isPaymentInProgress = false;

    debugPrint('❌ Payment Failed | Order: $orderId | '
          'Code: ${error.getCode()} | '
          'Message: ${error.getMessage()}',
    );

    Fluttertoast.showToast(
      msg: "Payment Failed: ${error.getMessage()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

}
