import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:wave_id/_provider/user_api_provider.dart';
import 'package:wave_id/features/_common/app_data.dart';
import 'package:wave_id/features/_common/custom_exception.dart';
import 'package:wave_id/features/_common/notification_utils.dart';
import 'package:wave_id/features/_services/app_service.dart';
import 'package:wave_id/features/_services/preference_service.dart';
import 'package:wave_id/features/pages/auth/auth_screen.dart';
import 'package:wave_id/features/pages/settings/settings_screen.dart';
import 'package:wave_id/model/ble_device.dart';
import 'package:wave_id/model/wave_card.dart';
import 'package:wave_id/utils/ble_utils.dart';

class HomeScreenX extends GetxController {
  static HomeScreenX get to => Get.find();

  AppService get _appStore => Get.find();

  PreferenceService get _preferenceService => Get.find();

  UserApiProvider get _userRepo => Get.find();

  BleDevice? matchingDevice;

  final scanState = BleScanState.initial.obs;

  final cards = List<WaveCard>.empty(growable: true).obs;

  final showLoading = false.obs;

  final error = RxnString();
  final success = RxnString();

  @override
  onInit() {
    fetchCards();
    super.onInit();
  }

  scanAndAuthenticateDefaultCard() async {
    scanState(BleScanState.initial);
    error.value = null;
    success.value = null;
    scanAndAuthenticate(await AppData.defaultCard);
  }

  scanAndAuthenticate(WaveCard waveCard) async {
    try {
      scanState(BleScanState.initial);

      if (!(await BleUtils.checkBluetoothPermission())) {
        return;
      }

      if (!(await BleUtils.checkLocationPermissions())) {
        return;
      }

      BleStatus? status = await BleUtils.checkBluetoothStatus();
      if (status == BleStatus.poweredOff || status == BleStatus.unknown) {
        NotificationUtils.showSimpleAlert(
          title: "bluetoothRequired".tr,
          message: "turnOnBluetooth".tr,
          confirmText: "goToSettings".tr,
          onConfirm: () {
            Get.back();
            AppSettings.openBluetoothSettings();
          },
        );

        scanState(BleScanState.bluetoothOff);

        return;
      }

      scanState(BleScanState.scanning);

      NotificationUtils.showSnackBar(
        message: "${"scanning".tr}...",
        showProgressIndicator: true,
        duration: const Duration(seconds: 30),
      );
      int rssiThreshold = _preferenceService.getRssiThreshold();

      matchingDevice = await BleUtils.scanForMatchingDevice(rssiThreshold);

      if (matchingDevice != null) {
        scanState(BleScanState.matchFound);

        List<int> encodedIdentifier;
        try {
          encodedIdentifier = await waveCard.encodedIdentifier;
        } catch (e) {
          throw CustomException("Invalid card Id.");
        }

        bool authenticated = (await BleUtils.authenticateDevice(
                matchingDevice!, encodedIdentifier)) ??
            false;

        if (authenticated) {
          scanState(BleScanState.authenticated);
          NotificationUtils.showSnackBar(
            message: "authenticated".tr,
            icon: const Icon(Icons.error, color: Colors.red),
          );
        } else {
          scanState(BleScanState.unauthenticated);
          NotificationUtils.showSnackBar(
            message: "unableToAuthenticate".tr,
            icon: const Icon(Icons.error, color: Colors.red),
          );
        }
      } else {
        scanState(BleScanState.matchNotFound);
        NotificationUtils.showSnackBar(
          message: "noMatchDevice".tr,
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {}
    return "result";
  }

  fetchCards() async {
    try {
      showLoading(true);

      cards.clear();

      cards.add(await AppData.defaultCard);

      if (_appStore.user.value != null) {
        List<WaveCard> userCards =
            await _userRepo.listCards(_appStore.user.value!.id);

        cards.addAll(userCards);
      }
    } catch (e) {
      NotificationUtils.showErrorSnackBar(message: e.toString());
    } finally {
      showLoading(false);
    }
  }

  showSettingsBottomSheet() =>
      Get.bottomSheet(const SettingsScreen(), isDismissible: true);

  openAuth() async {
    await Get.toNamed(AuthScreen.page.name);
    fetchCards();
  }
}

enum BleScanState {
  initial,
  scanning,
  matchFound,
  bluetoothOff,
  authenticated,
  unauthenticated,
  matchNotFound
}
