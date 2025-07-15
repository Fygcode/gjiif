import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/colors.dart';
import '../company/company_screen.dart';
import '../ebadge/ebadge_screen.dart';
import '../home/home_screen.dart';
import '../registered/registered_screen.dart';
import '../setting/setting_screen.dart';
import '../visitor/visitor_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Initialize the controller
  final DashboardController controller = Get.put(DashboardController());

  // Define your screens for each tab here
  static List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const VisitorScreen(),
    EbadgeScreen(eventTitle: "GJIIF",),
    const CompanyScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/GJIIF_Logo.png', height: 60, width: 60),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white,size: 30,),
              onPressed: () {
                Get.to(()=> SettingScreen());
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return _widgetOptions.elementAt(controller.selectedIndex.value);
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.secondary,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: Colors.black,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home_inactive.png',
                width: 30,
                height: 30,
                color:
                    controller.selectedIndex.value == 0
                        ? AppColor.primary
                        : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/visitor_inactive.png',
                width: 30,
                height: 30,
                color:
                    controller.selectedIndex.value == 1
                        ? AppColor.primary
                        : Colors.black,
              ),
              label: 'Employee List',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/registered_inactive.png',
                width: 30,
                height: 30,
                color:
                    controller.selectedIndex.value == 2
                        ? AppColor.primary
                        : Colors.black,
              ),
              label: 'Registered',
            ),

            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/company_inactive.png',
                width: 30,
                height: 30,
                color:
                    controller.selectedIndex.value == 3
                        ? AppColor.primary
                        : Colors.black,
              ),
              label: 'Company',
            ),
          ],
        );
      }),
    );
  }
}
