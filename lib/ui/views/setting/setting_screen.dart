import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/ui/views/setting/setting_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7DF),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Image.asset('assets/GJIIF_Logo.png', height: 35),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded (
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableTile(
                      title: "Terms & Conditions",
                      content: controller.termsContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Privacy Policy",
                      content: controller.privacyPolicyContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Refunds/Cancellation",
                      content: controller.refundCancellationContent,
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Shipping/Delivery",
                      content:
                          'Last updated on Feb. 01, 2023. Shipping is not applicable for business',
                    ),
                    SizedBox(height: 12),
                    _buildExpandableTile(
                      title: "Account Deletion and Data Retention",
                      content: controller.accountDeletion,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Version : 1.0.0"),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFCF4CB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
