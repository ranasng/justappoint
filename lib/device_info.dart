import 'dart:io';
import 'package:device_info/device_info.dart';
class DeviceDetails {
  
  Future<String> getDeviceId() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
      //  deviceName = build.model;
       // deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
       // deviceName = data.name;
        //deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print(e);
    }

//if (!mounted) return;
//return [deviceName, deviceVersion, identifier];
    return identifier;
  }
}
