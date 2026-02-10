import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'add_visitor_controller.dart';

class AddVisitorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddVisitorController>(
      AddVisitorController(),
      permanent: false,
    );
  }
}
