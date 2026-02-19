//************************* Imports *************************//
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

//************************* Ad Service *************************//
class AdService {
  static BannerAd? _bannerAd;

  //************************* Load Banner *************************//
  static Future<void> loadBannerAd(BuildContext context) async {
    final AdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );

    if (size == null) return;
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          debugPrint('✅ Banner loaded');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('❌ Banner failed: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  //************************* Get Banner Widget *************************//
  static Widget getBannerAdWidget() {
    if (_bannerAd == null) return const SizedBox.shrink();

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  //************************* Dispose *************************//
  static void disposeBannerAd() {
    _bannerAd?.dispose();
  }
}
