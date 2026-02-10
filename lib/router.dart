import 'package:get/get.dart';
import 'package:tjw1/ui/views/dashboard/dashboard_screen.dart';
import 'package:tjw1/ui/views/organization/organizationDetail_screen.dart';
import 'package:tjw1/ui/views/payment/payment_controller.dart';
import 'package:tjw1/ui/views/splash/splash_controller.dart';
import 'package:tjw1/ui/views/splash/splash_screen.dart';

import 'controllers/master_data_controller.dart';



class AppRoutes {
  static const String splash = '/';
  static const String loginScreen = '/login';
  static const String dashboardScreen = '/dashboard';
  static const String organizationScreen = '/organization_screen';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: organizationScreen,
      page: () => OrganizationDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    // Add more pages here
  ];
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(PaymentController(), permanent: true);
    Get.put(MasterDataController(), permanent: true);
  }
}

