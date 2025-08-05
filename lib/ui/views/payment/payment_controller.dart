// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:get/get.dart';
//
//
// class PaymentController extends GetxController {
//   RxString paymentStatus = ''.obs;
//
//   void initCashfree() {
//     CFPaymentGatewayService cfService = CFPaymentGatewayService();
//     cfService;
//
//     CFPaymentGatewayService(). ((CFPaymentGatewayEvent event) {
//       final cfEvent = event.getEventName();
//       final orderId = event.getOrderId();
//
//       switch (cfEvent) {
//         case CFEvent.SUCCESS:
//           Get.snackbar("Payment", "Success for Order ID: $orderId");
//           paymentStatus.value = "Success";
//           break;
//         case CFEvent.FAILED:
//           Get.snackbar("Payment", "Failed for Order ID: $orderId");
//           paymentStatus.value = "Failed";
//           break;
//         case CFEvent.DISMISSED:
//           Get.snackbar("Payment", "Dismissed by user");
//           paymentStatus.value = "Dismissed";
//           break;
//         default:
//           Get.snackbar("Payment", "Unknown event: $cfEvent");
//       }
//     });
//   }
//
//
//   void startPayment({required String orderId, required String orderToken}) {
//     final session = CFSessionBuilder()
//         .setEnvironment(CFEnvironment.SANDBOX)
//         .setOrderId(orderId)
//         .setPaymentSessionId(orderToken)
//         .build();
//
//     final payment = CFDropCheckoutPaymentBuilder()
//         .setSession(session)
//         .build();
//
//     CFPaymentGatewayService().doPayment(payment);
//   }
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     initCashfree();
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  RxString paymentStatus = ''.obs;

  final CFPaymentGatewayService _pgService = CFPaymentGatewayService();

  // @override
  // void onInit() {
  //   super.onInit();
  //   _pgService.initialize(); // REQUIRED!
  //   _pgService.setCallback((String? event, String? orderId) {
  //     switch (event) {
  //       case CFConstants.SUCCESS:
  //         paymentStatus.value = "Success";
  //         Get.snackbar("Payment", "Success: $orderId");
  //         break;
  //       case CFConstants.FAILED:
  //         paymentStatus.value = "Failed";
  //         Get.snackbar("Payment", "Failed: $orderId");
  //         break;
  //       case CFConstants.DISMISSED:
  //         paymentStatus.value = "Dismissed";
  //         Get.snackbar("Payment", "Dismissed by user");
  //         break;
  //       default:
  //         paymentStatus.value = "Unknown";
  //         Get.snackbar("Payment", "Unknown event: $event");
  //     }
  //   });
  // }

  //{
  //     required String orderId,
  //     required String orderToken,
  //   }
  void startPayment({
    required String orderId,
    required String orderToken,
  }
      ) {
    final session = CFSessionBuilder()
        .setEnvironment(CFEnvironment.SANDBOX)
        .setOrderId(orderId)  //
        .setPaymentSessionId(orderToken)
        .build();

    final cfWebCheckout = CFDropCheckoutPaymentBuilder().setSession(session).build();
    final cFPaymentGateway = CFPaymentGatewayService();

    cFPaymentGateway.setCallback((orderId){
     print("✅ Payment Successful for Order ID: $orderId");
     Fluttertoast.showToast(
       msg: "Payment Successful!",
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
       backgroundColor: Colors.green,
       textColor: Colors.white,
       fontSize: 16.0,
     );
     Get.offAllNamed('/dashboard');
    }, (p0,orderId){
      print(p0.getMessage());
      print(orderId);
      Fluttertoast.showToast(
        msg: "Payment Failed: ${p0.getMessage()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
    cFPaymentGateway.doPayment(cfWebCheckout);
  }
}



// {"cart_details":null,"cf_order_id":"2195519344","created_at":"2025-08-02T14:31:33+05:30","customer_details":{"customer_id":"71360","customer_name":null,"customer_email":null,"customer_phone":"9499956224","customer_uid":null},"entity":"order","order_amount":10.00,"order_currency":"INR","order_expiry_time":"2025-09-01T14:31:33+05:30","order_id":"order_9764430izgUuIAGQL7dddkP5Y4qhMZ0Q","order_meta":{"return_url":null,"notify_url":null,"payment_methods":null},"order_note":null,"order_splits":[],"order_status":"ACTIVE","order_tags":null,"payment_session_id":"session_Ol2JxD4dI0TmqcaP3FouZ8LUvzHgIJtFh2QsLGwCXZ7iFnlMlV4AaNrzMRgQJ9hUqispvF6cc7yvOQoGK6vrdMmAsUOzr4PIQRYIEvdG2bh6Sr02aXu5ytGuywpaymentpayment","terminal_data":null}


//curl --request POST \
//   --url https://sandbox.cashfree.com/pg/orders \
//   --header 'Content-Type: application/json' \
//   --header 'x-api-version: 2023-08-01' \
//   --header 'x-client-id: 97644cc98fa0f694b239a7cf344679' \
//   --header 'x-client-secret: 5461d06075cb72624170d5d0b3684c267e3fb752' \
//   --data '{
//   "order_amount": 10,
//   "order_currency": "INR",
//   "customer_details": {
//     "customer_id": "71360",
//     "customer_phone": "9499956224"
//   }
// }'