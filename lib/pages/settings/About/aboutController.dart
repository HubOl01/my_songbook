// import 'package:flutter_rustore_update/flutter_rustore_update.dart';
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

  @override
  void onInit() {
    super.onInit();
    // RustoreUpdateClient.info().then((info) {
    //   availableVersionCode.value = info.availableVersionCode;
    //   installStatus.value = info.installStatus;
    //   packageNameApp.value = info.packageName;
    //   updateAvailability.value = info.updateAvailability;
    // }).catchError((err) {
    //   error.value = err.toString();
    // });
    _load();
  }

  void _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName.value = packageInfo.appName;
    packageName.value = packageInfo.packageName;
    buildNumber.value = packageInfo.buildNumber;
    version.value = '${packageInfo.version} (${packageInfo.buildNumber})';

    isloading.value = false;
  }
}
