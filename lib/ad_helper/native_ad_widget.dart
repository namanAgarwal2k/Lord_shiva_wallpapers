import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  bool adLoaded = false;
  NativeAd? _ad;

  @override
  void initState() {
    super.initState();
    _ad = NativeAd(
      adUnitId:
          // 'ca-app-pub-3940256099942544/2247696110',
          'ca-app-pub-5328933201523290/7529213684',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as NativeAd;
            adLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad?.load();
  }

  @override
  void dispose() {
    // adLoaded = false;
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return adLoaded
        ? Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ), // width: _ad!.size.width.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: _ad!),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                border: Border.all(color: Colors.amberAccent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Ad is Loading..',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    letterSpacing: 1,
                    color: Colors.red),
              ),
            ),
          );
  }
}
