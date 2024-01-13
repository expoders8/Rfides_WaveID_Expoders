import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../features/_common/assets.dart';
import '../../../../features/_services/app_service.dart';
import '../../../../features/pages/home/home_screen.x.dart';
import '../../../../features/pages/home/view/waveid_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final page = GetPage(
    name: '/home',
    page: () => const HomeScreen(),
    binding: BindingsBuilder(() {
      Get.put(HomeScreenX());
    }),
  );

  AppService get _appStore => AppService.to;

  HomeScreenX get _homeScreenController => HomeScreenX.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      // backgroundColor: const Color(0xffcccccc),
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 30),
          child: Image.asset(
            Assets.appLogo,
            fit: BoxFit.fitHeight,
            width: Get.width * 0.3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(
            () => Offstage(
              offstage: !_appStore.isLoggedIn,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black87),
                onPressed: _homeScreenController.fetchCards,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: _homeScreenController.showSettingsBottomSheet,
          )
        ],
      ),
      body: const WaveIdWidget(),
    );
  }
}
