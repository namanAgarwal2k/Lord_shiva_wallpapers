import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'admobile_service.dart';
import 'appDrawer.dart';
import 'fullscreen.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AdManagerBannerAd bannerSize;
  // late BannerAd _bannerAd;
  // bool _isBannerLoaded = false;
  //
  // initState() {
  //   super.initState();
  //   _initBannerAd();
  // }
  //
  // _initBannerAd() {
  //   _bannerAd = BannerAd(
  //     adUnitId: BannerAd.testAdUnitId,
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (bannerAd) {
  //         setState(() {
  //           _isBannerLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (bannerAd, error) {
  //         print('Banner failed to load: $error');
  //       },
  //     ),
  //     request: AdRequest(),
  //   );
  //   _bannerAd.load();
  // }
  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  systemOverlayStyle: Get.isDarkMode
          //     ? SystemUiOverlayStyle.light
          //     : SystemUiOverlayStyle.dark,
          toolbarHeight: 50,
          title: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
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
                })
          ]),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('images').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?> x = snapshot.data!.docs[index];
              if (snapshot.hasData) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () async {
                          await AdmobService.createInterstitialAd();
                          AdmobService.showInterstitialAd();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                        imageUrl: x['imageUrl'],
                                      )));
                        },
                        child: ImageWidget(
                          imageUrl: x['imageUrl'],
                        ),
                      ),
                    ));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Oops something went wrong'),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
        // },
      ),
      bottomNavigationBar: AdSize.banner != null
          // AdmobService.bannerAd != null
          ? Container(
              color: Colors.transparent,
              child: AdWidget(
                key: UniqueKey(),
                ad: AdmobService.createBannerAd()..load(), //_bannerAd,
              ),
              height: AdSize.banner.height
                  .toDouble(), // AdmobService.bannerAdUnitId..height.toDouble(),
              width: AdSize.banner.width.toDouble(),
            )
          : SizedBox(),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Center(
              child: const Text(
                ' check your Internet Connection! \n😢',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
