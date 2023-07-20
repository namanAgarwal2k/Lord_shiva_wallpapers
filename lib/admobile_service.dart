import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdmobService {
  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;

  static BannerAd? get bannerAd => _bannerAd;
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5855901900811320/5834498530'
      : 'ca-app-pub-5855901900811320/5834498530'; //change ios ad on adding in real

  static String get iOSInterstitialAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-5855901900811320/9535133453'
      : 'ca-app-pub-5855901900811320/9535133453'; //change this on ios too

  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      //listener: null,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );

    return ad;
  }

  static void showBannerAd() {
    if (_bannerAd != null) {
      return;
    }
    _bannerAd = createBannerAd();
    _bannerAd!..load();
  }

  void disposeAds() {
    print("disposeAds");
    if (_bannerAd != null) {
      _bannerAd?.dispose();
    }
    if (_interstitialAd != null) {
      _interstitialAd?.dispose();
    }
  }

  static createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: iOSInterstitialAdUnitID,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      createInterstitialAd();
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();

        return;
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
