import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shiv_wallpaper/new/dialog_screen.dart';

class Fullscreen extends StatelessWidget {
  const Fullscreen({required this.url, Key? key}) : super(key: key);
  final String url;
  _save() async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
        quality: 60, name: "jai_mahadev");
  }

  setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  setLockScreen() async {
    int location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 2,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: Padding(
                  padding: const EdgeInsets.all(58.0),
                  child:
                      LinearProgressIndicator(value: downloadProgress.progress),
                )),
              ),
            ),
            Positioned(
              bottom: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.amber))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      optionDialog(
                        context: context,
                        onPressedFirst: () {
                          setWallpaper();
                          toast('Set as HomeScreen successfully');
                        },
                        onPressedSecond: () {
                          setLockScreen();
                          toast('Set as LockScreen successfully');
                        },
                        onPressedThird: () {
                          _save();
                          toast('Saved in gallery successfully');
                        },
                      );
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (context) {
                      //       return Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: <Widget>[
                      //             ListTile(
                      //               //   leading: new Icon(Icons.photo),
                      //               title: const Center(
                      //                   child: Text('Set as HomeScreen')),
                      //               onTap: () {
                      //                 setWallpaper();
                      //                 toast('Set as HomeScreen successfully');
                      //               },
                      //             ),
                      //             ListTile(
                      //               title: const Center(
                      //                   child: Text('Set as LockScreen')),
                      //               onTap: () {
                      //                 setLockScreen();
                      //                 toast('Set as LockScreen successfully');
                      //               },
                      //             ),
                      //             ListTile(
                      //               title:
                      //                   const Center(child: Text('Download')),
                      //               onTap: () {
                      //                 _save();
                      //                 toast('Saved in gallery successfully');
                      //               },
                      //             ),
                      //           ]);
                      //     });
                    },
                    child: const Text(
                      'Set',
                      style: TextStyle(
                          fontSize: 22, color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
