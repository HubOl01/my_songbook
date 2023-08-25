import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
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
    RustoreUpdateClient.info().then((info) {
      availableVersionCode.value = info.availableVersionCode;
      installStatus.value = info.installStatus;
      packageNameApp.value = info.packageName;
      updateAvailability.value = info.updateAvailability;
    }).catchError((err) {
      error.value = err.toString();
    });
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

  void updateApp() {
    RustoreUpdateClient.info().then((info) {
      if (info.updateAvailability == UPDATE_AILABILITY_AVAILABLE) {
        RustoreUpdateClient.listener((value) {
          print("listener installStatus ${value.installStatus}");
          print("listener bytesDownloaded ${value.bytesDownloaded}");
          print("listener totalBytesToDownload ${value.totalBytesToDownload}");
          print("listener installErrorCode ${value.installErrorCode}");

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");
            });
          }
        });

        RustoreUpdateClient.download().then((value) {
          print("download code ${value.code}");
          if (value.code == ACTIVITY_RESULT_CANCELED) {
            print("user cancel update");
          }
        }).catchError((err) {
          print("download err ${err}");
        });
      }
    }).catchError((err) {
      print(err.toString());
    });
  }
}
