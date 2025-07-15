// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SelectVisitorController extends GetxController{
//
//   List<bool> selected = List.generate(5, (index) => false); // 5 images
//
//   final TextEditingController filterController = TextEditingController();
//   FocusNode filterFocusNode = FocusNode();
//
//   RxList<bool> checkBoxSelected = <bool>[].obs;
//
//   int get selectedCount => checkBoxSelected.where((e) => e == true).length;
//
//   @override
//   void onInit() {
//     filterController.text = 'All';
//
//     checkBoxSelected.value = List<bool>.filled(selected.length, false);
//
//     super.onInit();
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectVisitorController extends GetxController {

  final RxList<bool> selected = List<bool>.filled(5, false).obs;


  int get selectedCount => selected.where((e) => e).length;

  final filterController = TextEditingController(text: 'All');
  final FocusNode filterFocusNode = FocusNode();
}
