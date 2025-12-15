import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class CustomAdNative extends StatefulWidget {
  const CustomAdNative({super.key});

  @override
  State<CustomAdNative> createState() => _CustomAdNativeState();
}

class _CustomAdNativeState extends State<CustomAdNative> {
  late BannerAd banner;
  var isBannerAlreadyCreated = false;
  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  _loadAd() async {
    banner = _createBanner();
    isBannerAlreadyCreated = true;
    // if banner was already created you can just call:    // if banner was already created you can just call:
    banner.loadAd(adRequest: const AdRequest());
  }

  BannerAdSize getAdSize() {
    final screenWidth = MediaQuery.of(Get.context!).size.width.round();
    return BannerAdSize.sticky(width: screenWidth);
  }

  _createBanner() {
    return BannerAd(
        adUnitId: dotenv.env[
            'AdsNative']!, // or 'demo-banner-yandex'        adUnitId: dotenv.env['ADs']!, // or 'demo-banner-yandex'
        adSize: getAdSize(),
        adRequest: const AdRequest(),
        onAdLoaded: () {
          // The ad was loaded successfully. Now it will be shown.
          // if (banner.loadAd()) {          // if (banner.loadAd()) {
          // banner.destroy();          // banner.destroy();
          // return;
          // }
        },
        onAdFailedToLoad: (error) {
          isBannerAlreadyCreated = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return AdWidget(bannerAd: banner);
  }
}
