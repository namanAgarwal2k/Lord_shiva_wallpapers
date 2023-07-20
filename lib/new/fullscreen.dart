
import 'dart:typed_data';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';


class Fullscreen extends StatelessWidget {
   const Fullscreen({required this.url,Key? key}) : super(key: key);
final String? url;
   _save() async {
     var response = await Dio().get(
         url!,
         options: Options(responseType: ResponseType.bytes));
     final result = await ImageGallerySaver.saveImage(
         Uint8List.fromList(response.data),
         quality: 60,
         name: "hello");
     print(result);
   }
  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();

    shareImage() async{
    screenshotController.capture(delay:const Duration(milliseconds: 100),pixelRatio: 1.0).then((Uint8List? url)async{
    if(url!=null){
        final directory = (await getApplicationDocumentsDirectory()).path;
        final filename = "${DateTime.now().microsecondsSinceEpoch}.png";
        final imgPath = await File("${directory}/$filename").create();
        await imgPath.writeAsBytes(url);
        Share.shareFiles([imgPath.path],text: 'Created by -SudoStudio');
      }else{
      print('null error');
    }
    });
}
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 2,),
       extendBodyBehindAppBar: true,
      body:
      Stack(
        alignment: Alignment.center,
        children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child:
          Screenshot(

              controller: screenshotController,
              child:CachedNetworkImage(fit: BoxFit.cover, imageUrl: url!,progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: Padding(
                    padding: const EdgeInsets.all(58.0),
                    child: LinearProgressIndicator(value: downloadProgress.progress),
                  )),)),
        ),
        Positioned(
          bottom: 2,
          child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton( onPressed: (){
                      _save();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved successfully')));
                    },child: const Text('Save'),
                    ),
                   const SizedBox(width: 8,),
                    ElevatedButton(onPressed: (){
                      shareImage();
                    }, child: const Text('Share'))
                  ],
               ),
        ),
      ],)



      // floatingActionButton: FloatingActionButton(
      //   child:const Text('Save'),
      //   onPressed: (){
      //     _save();
      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved successfully')));
      //   },
      // ),
    );
  }
}
