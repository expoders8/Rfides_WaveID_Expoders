import 'package:get/get.dart';

import '../../../flavor_service.dart';
import '../../../_translation/app_locale.dart';
import '../../../features/_services/app_service.dart';
import '../../../features/pages/home/home_screen.x.dart';
import '../../../features/_common/notification_utils.dart';
import '../../../features/pages/settings/eula_screen.dart';
import '../../../features/_services/preference_service.dart';
import '../../../features/pages/settings/about_us_screen.dart';
import '../../../features/pages/settings/view/rssi_setting_dialog.dart';

class SettingsScreenX extends GetxController {
  static SettingsScreenX get to => Get.find();

  final RxInt rssi = PreferenceService.to.getRssiThreshold().obs;

  onResetAppHandler() {
    NotificationUtils.showSimpleAlert(
      title: "resetApplication".tr,
      message: "resetApplicationMessage".tr,
      confirmText: "reset".tr,
      onConfirm: () async {
        AppService.to.logout();
        await HomeScreenX.to.fetchCards();
        await PreferenceService.to.clear();
        Get.back();
      },
    );
  }

  onRssiClickHandler() async {
    await Get.dialog(RssiSettingDialog());
    rssi(PreferenceService.to.getRssiThreshold());
  }

  openAboutUsPage() => Get.to(const AboutUsScreen());

  openEula() {
    Get.back();
    Get.to(
      () => EulaScreen(
        asset:
            '${FlavorService.to.assetsFolder}${FlavorService.to.eulaAssetHtml}',
      ),
    );
  }

  late final _initialLocale = PreferenceService.to.getLocale();

  late final selectedLocale = _initialLocale.obs;

  void changeLocale() {
    if (selectedLocale.value != null) {
      PreferenceService.to.setLocale(selectedLocale.value!);
      Get.updateLocale(selectedLocale.value!.locale);
    }
    Get.back(result: false);
  }

  void cancelLocale() {
    selectedLocale.value = PreferenceService.to.getLocale();
  }

  void resetLocale() {
    cancelLocale();
    Get.back(result: false);
  }
}
