import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
// import 'package:yandex_mobileads/mobile_ads.dart';

import 'db/dbSongs.dart';
import 'model/songsModel.dart';

class GuitarController extends GetxController {
  var songs = <Song>[].obs;
  var isLoading = false.obs;
  // late BannerAd banner;
  var isBannerAlreadyCreated = false.obs;
  @override
  void onInit() {
    super.onInit();
    // MobileAds.initialize();
    // MobileAds.setUserConsent(true);
    // _loadAd();
    refreshSongs();
  }

  @override
  void dispose() {
    DBSongs.instance.close();
    // banner.destroy();
    super.dispose();
  }

  Future refreshSongs() async {
    isLoading.value = true;
    songs.value = await DBSongs.instance.readAllSongs();

    isLoading.value = false;
  }

  // _loadAd() async {
  //   banner = _createBanner();
  //   isBannerAlreadyCreated.value = true;
  //   // if banner was already created you can just call:
  //   banner.loadAd(adRequest: const AdRequest());
  // }

  // BannerAdSize getAdSize() {
  //   final screenWidth = MediaQuery.of(Get.context!).size.width.round();
  //   return BannerAdSize.sticky(width: screenWidth);
  // }

  // _createBanner() {
  //   return BannerAd(
  //       adUnitId: dotenv.env['ADs']!, // or 'demo-banner-yandex'
  //       adSize: getAdSize(),
  //       adRequest: const AdRequest(),
  //       onAdLoaded: () {
  //         // The ad was loaded successfully. Now it will be shown.
  //         // if (banner.loadAd()) {
  //         // banner.destroy();
  //         // return;
  //         // }
  //       },
  //       onAdFailedToLoad: (error) {
  //         isBannerAlreadyCreated.value = false;
  //       });
  // }
}
