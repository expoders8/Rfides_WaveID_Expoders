import 'package:wave_id/flavor_service.dart';

class Assets {
  static String get appLogo => '${FlavorService.to.assetsFolder}app_logo.png';
  static String get appLogo2 => '${FlavorService.to.assetsFolder}app_logo2.png';
  static String? get homeBackground => FlavorService.to.homeBackground == null
      ? null
      : '${FlavorService.to.assetsFolder}${FlavorService.to.homeBackground}';
}
