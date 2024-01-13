import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../features/_services/app_service.dart';

class SplashScreenX extends GetxController {
  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        AppService.to.init();
      });
    });
  }
}
