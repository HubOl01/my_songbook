// import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController extends GetxController {
  var availableVersionCode = 0.obs;
  var installStatus = 0.obs;
  var packageNameApp = "".obs;
  var updateAvailability = 0.obs;
  var error = "".obs;

  var appName = ''.obs;
  var packageName = ''.obs;
  var version = ''.obs;
  var buildNumber = ''.obs;
  var isloading = true.obs;
  var deviceInfo = {}.obs;
  @override
  void onInit() {
    super.onInit();
    _load();
    fetchDeviceInfo();
  }

  void _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName.value = packageInfo.appName;
    packageName.value = packageInfo.packageName;
    buildNumber.value = packageInfo.buildNumber;
    version.value = '${packageInfo.version} (${packageInfo.buildNumber})';

    isloading.value = false;
  }

  Future<void> fetchDeviceInfo() async {
    isloading.value = true;
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      Map<String, dynamic> info;

      if (GetPlatform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        info = {
          'Application version': version.value,
          'Package name': packageName.value,
          'Brand': androidInfo.brand,
          'Model': androidInfo.model,
          'Android Version': androidInfo.version.release,
          'SDK Version': androidInfo.version.sdkInt.toString(),
          'Device': androidInfo.device,
          'Manufacturer': androidInfo.manufacturer,
        };
      } else if (GetPlatform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        info = {
          'Name': iosInfo.name,
          'System Name': iosInfo.systemName,
          'System Version': iosInfo.systemVersion,
          'Model': iosInfo.model,
          'Localized Model': iosInfo.localizedModel,
          'Identifier for Vendor': iosInfo.identifierForVendor,
        };
      } else {
        info = {'Error': 'Unsupported platform'};
      }

      deviceInfo.value = info;
    } catch (e) {
      deviceInfo.value = {'Error': e.toString()};
    } finally {
      isloading.value = false;
    }
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied",
      "Device information copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 2),
    );
  }
}
