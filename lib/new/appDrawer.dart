import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

// import 'admobile_service.dart';

class AppDrawer extends StatelessWidget {
  // final Uri url =
  //     Uri.parse("https://sites.google.com/view/shiv-ji-hd-wallpapers/home");
  // Future<void> openUrl() async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }
  openUrl() async {
    // ignore: deprecated_member_use
    if (await canLaunch(
        "https://sites.google.com/view/shiv-ji-hd-wallpapers/home")) {
      // ignore: deprecated_member_use
      await launch("https://sites.google.com/view/shiv-ji-hd-wallpapers/home");
    } else {
      throw 'Could not launch Url, please check your connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appPackageName = 'com.sudoStudio.shiv_wallpaper';
    String strAppLink = "";

    try {
      strAppLink =
          "https://play.google.com/store/apps/details?id=$appPackageName";
      //strAppLink = "market://details?id=" + appPackageName;
    } catch (error) {
      throw 'Sorry, could not launch Url, might be server error!';
      // strAppLink =
      //     "https://play.google.com/store/apps/details?id=" + appPackageName;
    }
    // print(strAppLink);
    // print(appPackageName);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Colors.tealAccent,
              toolbarHeight: 180,
              title: const Text(
                ' ::: Jai BholeNath :::',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              automaticallyImplyLeading: false, //back button of
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.share,
              ),
              title: const Text('Share with friends'),
              onTap: () {
                Share.share(strAppLink);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () {
                openUrl();
              },
              selectedTileColor: Colors.red,
            ),
            // Divider(),
            // Container(
            //   height: AdSize.banner.height.toDouble(),
            //   width: AdSize.banner.width.toDouble(),
            //   child: AdWidget(
            //       key: UniqueKey(), ad: AdmobService.createBannerAd()..load()),
            // ),
          ],
        ),
      ),
    );
  }
}
