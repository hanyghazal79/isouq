import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'admob_banner.dart';
import 'admob_banner_size.dart';

const String testDevice = 'kGADSimulatorID';

class GoogleAdMob {
  static final GoogleAdMob _sharedInstance = GoogleAdMob._internal();

  factory GoogleAdMob() {
    FirebaseAdMob.instance.initialize(
      appId: Platform.isAndroid
          ? 'ca-app-pub-2004979416587198~3399203318'       // <= '[FIREBASE_ADDMOB_ANDROID_ID]'
          : '[FIREBASE_ADDMOB_iOS_ID]',
    );

    initializeAds();
    return _sharedInstance;
  }

  GoogleAdMob._internal();

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static AdmobBanner _bannerAd;
  static InterstitialAd _interstitialAd;

  static void initializeAds() {
    _bannerAd = createBannerAd();

    _interstitialAd = createInterstitialAd();

    RewardedVideoAd.instance.load(
        adUnitId: 'ca-app-pub-2004979416587198/4461003549',       // <= '[ADDMOB_RewardedVideoAd_ID]',
        targetingInfo: targetingInfo);
  }

  Widget loadBannerAdd() {
    return _bannerAd ;
  }

  void loadInterstitialAd() {
    _interstitialAd
      ..load()
      ..show();
  }

  void loadRewardedVideoAd() {
    RewardedVideoAd.instance.show();
  }

  static AdmobBanner createBannerAd() {
    return AdmobBanner(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-2004979416587198/2601126960':'[ADDMOB_iOS_AdmobBanner_ID]',
      adSize: AdmobBannerSize.FULL_BANNER,
    );
  }

  static InterstitialAd createInterstitialAd() {
    return InterstitialAd(
//      adUnitId: InterstitialAd.testAdUnitId,
      adUnitId: 'ca-app-pub-2004979416587198/2409555274',       // <= '[ADDMOB_InterstitialAd_ID]',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  void disposeAds() {
//    if (_bannerAd != null) _bannerAd?.dispose();
    if (_interstitialAd != null) _interstitialAd?.dispose();
  }
}
