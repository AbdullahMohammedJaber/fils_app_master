/*
import 'package:fils/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsProvider with ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  BannerAd? get bannerAd => _bannerAd;

  Future<void> initBannerAd(String adId) async {
    _bannerAd = BannerAd(
      adUnitId: adId,

      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          _isLoaded = false;
          ad.dispose();

          Future.delayed(const Duration(seconds: 1), () {
            initBannerAd(adId);
          });
        },
      ),
    );
    await _bannerAd!.load();
  }

  void hideBanner() {
    _isLoaded = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
*/
