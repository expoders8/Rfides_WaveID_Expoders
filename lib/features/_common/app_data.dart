import 'package:get/get.dart';
import 'package:wave_id/flavor_service.dart';
import 'package:wave_id/model/wave_card.dart';
import 'package:wave_id/utils/tea_utils.dart';

class AppData {
  static String? _identifier;

  static Future<String> get deviceIdentifier async {
    _identifier ??= await TeaHelper.getDeviceIdentifier();
    return _identifier!;
  }

//  static Uint8List _encodedHexArray;

//  static Future<Uint8List> get encodedIdentifier async {
//    _encodedHexArray ??=
//        await TeaHelper.getIdentifierAsUInt8List(await deviceIdentifier);
//    return _encodedHexArray;
//  }

  static WaveCard? _defaultCard;

  static Future<WaveCard> get defaultCard async {
    if (_defaultCard == null) {
      var identifier = await deviceIdentifier;
      _defaultCard ??= WaveCard(
        "DEFAULT_CARD",
        Get.find<FlavorService>().defaultCardName,
        identifier,
      );
    }
    return _defaultCard!;
  }
}
