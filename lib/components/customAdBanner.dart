import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class CustomAdBanner extends StatefulWidget {
  final bool isListTile;
  final bool isView;
  const CustomAdBanner(
      {super.key, this.isListTile = false, this.isView = false});

  @override
  State<CustomAdBanner> createState() => _CustomAdBannerState();
}

class _CustomAdBannerState extends State<CustomAdBanner> {
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
    // if banner was already created you can just call:
    banner.loadAd(adRequest: const AdRequest());
  }

  @override
  void dispose() {
    super.dispose();
  }

  BannerAdSize getAdSize() {
    final screenWidth = MediaQuery.of(Get.context!).size.width.round();
    return widget.isListTile
        ? BannerAdSize.inline(width: screenWidth, maxHeight: 60)
        : BannerAdSize.sticky(width: screenWidth);
  }

  _createBanner() {
    final random = Random();
    final adUnitId = random.nextBool()
        ? '${dotenv.env['AdsKey']}-3'
        : '${dotenv.env['AdsKey']}-1';
    final random2 = Random();
    isBannerAlreadyCreated = widget.isView
        ? true
        : random2.nextDouble() < 0.7; // 70% true и 30% false
    return isBannerAlreadyCreated
        ? BannerAd(
            adUnitId: adUnitId,
            // or 'demo-banner-yandex'        adUnitId: dotenv.env['ADs']!, // or 'demo-banner-yandex'
            adSize: getAdSize(),
            adRequest: const AdRequest(),
            onAdLoaded: () {
              // The ad was loaded successfully. Now it will be shown.
            },
            onAdClicked: () {
              // Called when a click is recorded for an ad.
            },
            onLeftApplication: () {
              // Called when user is about to leave application (e.g., to go to the browser), as a result of clicking on the ad.
            },
            onReturnedToApplication: () {
              // Called when user returned to application after click.
            },
            onImpression: (impressionData) {
              // Called when an impression is recorded for an ad.
            },
            onAdFailedToLoad: (error) {
              // Ad failed to load with AdRequestError.
              // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
              isBannerAlreadyCreated = false;
            })
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return AdWidget(bannerAd: banner);
  }
}
