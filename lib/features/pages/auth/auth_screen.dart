import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../features/pages/auth/auth_screen.x.dart';
import '../../../features/_widgets/loading_container.dart';
import '../../../features/pages/auth/view/otp_input_view.dart';
import '../../../features/pages/auth/view/qr_code_scanner.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static final page = GetPage(
    name: '/auth',
    page: () => const AuthScreen(),
    binding: BindingsBuilder(() {
      Get.put(AuthScreenX());
    }),
  );

  AuthScreenX get _authScreenStore => Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => LoadingContainer(
            isLoading: _authScreenStore.showLoading.value,
            child: Obx(
              () {
                var state = _authScreenStore.screenState.value;
                switch (state) {
                  case AuthScreenStateKind.otpInput:
                    return const OtpInputView();

                  case AuthScreenStateKind.scanner:
                  default:
                    return const QrCodeScanner();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
