import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tjw1/ui/views/splash/splash_controller.dart';

import '../../../helper/update_checker.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    print("INSIDE SPLASH SCREEN");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match your theme
      body: Stack(
        fit: StackFit.expand,
        children: [
          Text("Muthuraksjds"),
          Image.asset(
            'assets/splash_background.png', // Optional full background
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
