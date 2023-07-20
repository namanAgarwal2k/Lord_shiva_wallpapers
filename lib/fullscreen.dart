import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FullScreen extends StatefulWidget {
  final imageUrl;

  FullScreen({required this.imageUrl});

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(widget.imageUrl,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "hello");
      print(result);
      print(widget.imageUrl);
    }
  }

  setWallpaper() async {
    int location = WallpaperManagerFlutter.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
    WallpaperManagerFlutter().setwallpaperfromFile(file, location);
  }

  setLockScreen() async {
    int location = WallpaperManagerFlutter.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
    WallpaperManagerFlutter().setwallpaperfromFile(file, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor:
            Colors.transparent, //Color.fromARGB(68, 255, 253, 253),
        title: Text(
          'Lord Shiva',
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 50,
      ),
      body: Container(
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    //   borderRadius: BorderRadius.circular(10.0),
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: widget.imageUrl,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              //     ),
            ],
          ),
          Container(
              child: Positioned(
            bottom: 20,
            left: 128,
            right: 128,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              //   leading: new Icon(Icons.photo),
                              title:
                                  Center(child: new Text('Set as HomeScreen')),
                              onTap: () {
                                setWallpaper();
                                toast('Set as HomeScreen successfully');
                              },
                            ),
                            ListTile(
                              title:
                                  Center(child: new Text('Set as LockScreen')),
                              onTap: () {
                                setLockScreen();
                                toast('Set as LockScreen successfully');
                              },
                            ),
                            ListTile(
                              title: Center(child: new Text('Download')),
                              onTap: () {
                                _save();
                                toast('Saved in gallery successfully');
                              },
                            ),
                          ]);
                    });
              },
              child: Text(
                'Set',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )),
          //  ]),
        ]),
      ),
    );
  }
}
