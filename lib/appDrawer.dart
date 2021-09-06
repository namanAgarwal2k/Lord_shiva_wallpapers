import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class AppDrawer extends StatelessWidget {
  openUrl() async {
    if (await canLaunch(
        "https://sites.google.com/view/shiv-ji-hd-wallpapers/home")) {
      await launch("https://sites.google.com/view/shiv-ji-hd-wallpapers/home");
    } else {
      throw 'Could not launch Url, please check your connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String appPackageName = 'com.sudoStudio.shiv_wallpaper';
    String strAppLink = "";

    try {
      strAppLink =
          "https://play.google.com/store/apps/details?id=" + appPackageName;
      //strAppLink = "market://details?id=" + appPackageName;
    } catch (error) {
      throw 'Sorry, could not launch Url, might be server error!';
      // strAppLink =
      //     "https://play.google.com/store/apps/details?id=" + appPackageName;
    }
    print(strAppLink);
    print(appPackageName);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Colors.tealAccent,
              toolbarHeight: 180,
              title: Text(
                ' ::: Jai BholeNath :::',
                // style: GoogleFonts.rajdhani(
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              automaticallyImplyLeading: false, //back button of
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.share,
              ),
              title: Text('Share with friends'),
              onTap: () {
                Share.share(strAppLink);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy Policy'),
              onTap: () {
                openUrl();
              },
            ),
          ],
        ),
      ),
    );
  }
}
