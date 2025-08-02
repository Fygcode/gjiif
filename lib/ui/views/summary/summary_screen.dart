import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tjw1/common_widget/common_button.dart';
import 'package:tjw1/core/model/tjw/payment_summary_response.dart';
import 'package:tjw1/core/res/colors.dart';
import 'package:tjw1/ui/views/summary/summary_controller.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final SummaryController controller = Get.put(SummaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Payment Summary", style: TextStyle(color: AppColor.black)),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return Center(child: CircularProgressIndicator());
        }
        return  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: 80,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(controller.eventDetail.eventLogoURL!),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.eventDetail.eventName!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            controller.eventDetail.date!,
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            controller.eventDetail.venue!,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColor.tertiary),
                  child: Column(
                    children: List.generate(controller.visitorSummaryList.length, (index) {
                      VisitorSummary entry = controller.visitorSummaryList[index];
                      final bgColor =
                      index % 2 == 0 ? controller.color1 : controller.color2;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.visitorName!,
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                            ),
                            Text(
                              '₹ ${entry.preRegistrationFee.toString()}',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),

                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Payment Detail",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColor.tertiary),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "₹${controller.totalPayableAmount}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),


      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: CommonButton(
                text: "Cancel",
                onPressed: () {
                  Get.back();
                },
                fillColor: AppColor.secondary,
                textColor: AppColor.black,
              ),
            ),
            SizedBox(width: 15),
            Expanded(child: CommonButton(text: "Pay Now", onPressed: () {})),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
