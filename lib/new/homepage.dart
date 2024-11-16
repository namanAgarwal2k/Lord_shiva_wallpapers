import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import 'appDrawer.dart';
import 'firebase.dart';
import 'fullscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  InterstitialAd? _interstitialAd;
  bool interstitialAdLoaded = false;
  // late NativeAdWidget nativeAdWidget;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = 'ca-app-pub-5328933201523290/2099069206';

  @override
  void initState() {
    loadInterstitialAd();
    // nativeAdWidget = NativeAdWidget();
    super.initState();
  }

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            setState(() {
              _interstitialAd = ad;
              interstitialAdLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void _showInterstitialAd(String imgPath) {
    if (interstitialAdLoaded) {
      _interstitialAd?.show();
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Fullscreen(
                      url: imgPath,
                    )),
          );
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Interstitial Ad failed to show: $error');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Fullscreen(
                      url: imgPath,
                    )),
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Fullscreen(
                  url: imgPath,
                )),
      );
    }
  }

  @override
  void dispose() {
    setState(() {
      _interstitialAd?.dispose();
      interstitialAdLoaded = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchState = ref.watch(streamProvider);

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 50,
            title: Center(
              child: Text(
                'Jai BholeNath',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                    letterSpacing: 1),
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode),
                  onPressed: () {
                    MyApp.themeNotifier.value =
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                  }),
              // IconButton(
              //     onPressed: () {
              //       navigatorKey.currentState?.pushNamed(
              //         NotificationScreen.route,
              //       );
              //     },
              //     icon: Icon(Icons.notifications))
            ]),
        drawer: AppDrawer(),
        body: watchState.when(
          data: (data) {
            return StaggeredGridView.countBuilder(
              itemCount: data.length,
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) {
                if ((index % (data.length - 1) == 0) && index != 0) {
                  // Set the ad tile to span two columns and one row
                  return StaggeredTile.count(2, 3.2); //2, 1.85
                } else {
                  // Set the grid item tile to span one column and one row
                  return StaggeredTile.count(1, 1.6);
                }
              },
              itemBuilder: (context, index) {
                String imgPath = data[index]!['imageUrl'];
                // if ((index % (data.length - 1) == 0) && index != 0) {
                //   return nativeAdWidget;
                // } else
                // {
                return InkWell(
                  onTap: () {
                    _showInterstitialAd(imgPath);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 340,
                        maxWidthDiskCache: 240,
                        fit: BoxFit.cover,
                        imageUrl: imgPath,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(58.0),
                            child: LinearProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (context, error) => const Icon(Icons.error),
          loading: () {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          },
        ));
  }
}
