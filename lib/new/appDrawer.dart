import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  openUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
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
    }

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
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.star_rate,
              ),
              title: const Text('Rate Us'),
              onTap: () {
                openUrl(strAppLink);
                // Share.share(strAppLink);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () {
                openUrl(
                    'https://sites.google.com/view/shiv-ji-hd-wallpapers/home');
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
