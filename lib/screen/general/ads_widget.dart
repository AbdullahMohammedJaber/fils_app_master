/*
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/admob_ads_provider.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<BannerAdsProvider>();

    if (!adsProvider.isLoaded || adsProvider.bannerAd == null) {
      return const SizedBox(height: 0);
    }

    return Container(
      alignment: Alignment.center,
      width: adsProvider.bannerAd!.size.width.toDouble(),
      height: adsProvider.bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: adsProvider.bannerAd!),
    );
  }
}
*/
