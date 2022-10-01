import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdState with ChangeNotifier{
  Future<InitializationStatus> initialization;

  AdState({required this.initialization});

  BannerAd? homeBanner;
  BannerAd? chemistryBanner;
  BannerAd? mathsBanner;
  BannerAd? physicsBanner;

  InterstitialAd? _interstitialAd;
  FullScreenContentCallback<InterstitialAd>? interstitialFullScreenContentCallback;
  InterstitialAdLoadCallback? interstitialAdLoadCallback;

  final String bannerTestIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  final String bannerTestIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  final String interstitialTestIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  final String interstitialTestIdIOS = 'ca-app-pub-3940256099942544/1033173712';

  //Banner AND Interstitial Ad IDs
  final String bannerIdAndroid = 'ca-app-pub-3011622144286710/2175694164';
  final String interstitialIdAndroid = 'ca-app-pub-3011622144286710/3743641295';

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) { print(' Banner Ad failed to load: ${ad.adUnitId}, ${error.message}.');},
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClicked: (ad) => print('Ad clicked: ${ad.adUnitId}.'),
    onAdImpression: (ad) => print('Ad impression: ${ad.adUnitId}.'),
  );


  String get bannerAdUnitId => Platform.isAndroid ? bannerIdAndroid : bannerTestIdIOS;
  String get interstitialAdUnitId => Platform.isAndroid ? interstitialIdAndroid : interstitialTestIdIOS;
  InterstitialAd? get interstitialAd => _interstitialAd;
  BannerAdListener get bannerAdListener => _bannerAdListener;

  set interstitialAd (InterstitialAd? ad) {
    _interstitialAd = ad;
    notifyListeners();
  }

  void loadInterstitialAd() {
     InterstitialAd.load(adUnitId: interstitialAdUnitId, request: const AdRequest(), adLoadCallback: setInterstitialAdLoadCallback()!);
  }
  void loadBannerAd(BannerAd? ad){
    ad = BannerAd(size: AdSize.fullBanner, adUnitId: bannerAdUnitId, listener: bannerAdListener, request: const AdRequest())..load();
    notifyListeners();
    print(ad.adUnitId);
  }

  void showInterstitialAd(){
    interstitialAd?.fullScreenContentCallback = setInterstitialFullScreenContentCallback();
    try {
      interstitialAd?.show();
    } on Exception catch (e) {
      print(e);
    }
    print(interstitialAd?.adUnitId);
  }

  InterstitialAdLoadCallback? setInterstitialAdLoadCallback() {
    interstitialAdLoadCallback = InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          print('ad loaded: ${interstitialAd?.adUnitId}');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('interstitial ad failed to load: ${interstitialAd?.adUnitId}, $error');
          interstitialAd = null;
        }
    );
    return interstitialAdLoadCallback;
  }
  FullScreenContentCallback<InterstitialAd>? setInterstitialFullScreenContentCallback() {
    interstitialFullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          print('$ad onAdDismissed content');
          ad.dispose();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad,error){
          print('$ad onAdFailedToLoad content');
          ad.dispose();
          loadInterstitialAd();
        }
    );
    return interstitialFullScreenContentCallback;
  }


}