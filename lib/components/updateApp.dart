import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';

int availableVersionCode = 0;
int installStatus = 0;
String packageName = "";
int updateAvailability = 0;
String infoErr = "";

int bytesDownloaded = 0;
int totalBytesToDownload = 0;
int installErrorCode = 0;

String completeErr = "";
int installCode = 0;

String updateError = "";
String silentError = "";
String immediateError = "";

void updateApp() {
  RustoreUpdateClient.info().then((info) {
    AppMetrica.reportEvent('updateApp');
    availableVersionCode = info.availableVersionCode;
    installStatus = info.installStatus;
    packageName = info.packageName;
    updateAvailability = info.updateAvailability;

    if (info.updateAvailability == UPDATE_AILABILITY_AVAILABLE) {
      AppMetrica.reportEvent('UPDATE_AILABILITY_AVAILABLE');
      RustoreUpdateClient.listener((value) {
        print("listener installStatus ${value.installStatus}");
        print("listener bytesDownloaded ${value.bytesDownloaded}");
        print("listener totalBytesToDownload ${value.totalBytesToDownload}");
        print("listener installErrorCode ${value.installErrorCode}");
        installStatus = value.installStatus;
        bytesDownloaded = value.bytesDownloaded;
        totalBytesToDownload = value.totalBytesToDownload;
        installErrorCode = value.installErrorCode;

        if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
          AppMetrica.reportEvent('INSTALL_STATUS_DOWNLOADED');
          RustoreUpdateClient.complete().catchError((err) {
            print("complete err ${err}");

            completeErr = err.message;
          });
        }
      });

      RustoreUpdateClient.download().then((value) {
        print("download code ${value.code}");
        AppMetrica.reportEvent('RustoreUpdateClient.download ${value.code}');
        installCode = value.code;

        if (value.code == ACTIVITY_RESULT_CANCELED) {
          print("user cancel update");
        }
      }).catchError((err) {
        print("download err ${err}");

        updateError = err.message;
      });
    }
  }).catchError((err) {
    print(err.toString());

    infoErr = err.message;
  });
}

  void silent() {
    RustoreUpdateClient.info().then((info) {
      AppMetrica.reportEvent('silent');
        availableVersionCode = info.availableVersionCode;
        installStatus = info.installStatus;
        packageName = info.packageName;
        updateAvailability = info.updateAvailability;

      if (info.updateAvailability == UPDATE_AILABILITY_AVAILABLE) {
        RustoreUpdateClient.listener((value) {
          print("listener installStatus ${value.installStatus}");
          print("listener bytesDownloaded ${value.bytesDownloaded}");
          print("listener totalBytesToDownload ${value.totalBytesToDownload}");
          print("listener installErrorCode ${value.installErrorCode}");

            installStatus = value.installStatus;
            bytesDownloaded = value.bytesDownloaded;
            totalBytesToDownload = value.totalBytesToDownload;
            installErrorCode = value.installErrorCode;

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");
                completeErr = err.message;
            });
          }
        });

        RustoreUpdateClient.silent().then((value) {
          print("silent code ${value.code}");
            installCode = value.code;
        }).catchError((err) {
          print("silent err ${err}");
            silentError = err.message;
        });
      }
    }).catchError((err) {
      print(err.toString());
        infoErr = err.message;
    });
  }
