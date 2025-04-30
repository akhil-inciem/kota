// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FindController extends GetxController with GetSingleTickerProviderStateMixin {
//   late TabController tabController;
//   var isTermsAccepted = false.obs; // reactive boolean

//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void onClose() {
//     tabController.dispose();
//     super.onClose();
//   }

//   void toggleTermsAccepted() {
//     isTermsAccepted.value = !isTermsAccepted.value;
//   }
// }
