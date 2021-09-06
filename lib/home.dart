import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appDrawer.dart';
import 'fullscreen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList = [];
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("images");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
  // void ClearCache() {
  //   DefaultCacheManager().emptyCache();
  //   imageCache!.clear();
  //   imageCache!.clearLiveImages();
  //   setState(() {});
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   ClearCache();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                onPressed: () {
                  AdaptiveTheme.of(context).toggleThemeMode();
                },
                icon: Icon(CupertinoIcons.lightbulb),
              )
            ]),
        drawer: AppDrawer(),
        body: wallpapersList != null
            ?
            //SingleChildScrollView(
            // physics: ScrollPhysics(),
            //  child:
            Padding(
                padding: const EdgeInsets.fromLTRB(
                  5,
                  7,
                  5,
                  0,
                ),
                child: // FutureBuilder(
                    Column(
                  //      mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child:
                          // StreamBuilder(
                          //   stream:
                          //       FirebaseFirestore.instance.collection("images").snapshots(),
                          //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          //     if (snapshot.hasData) {
                          //       return
                          GridView.builder(
                        shrinkWrap: true,
                        //     physics: ScrollPhysics(),
                        primary: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.74,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 3),
                        itemCount: wallpapersList.length,
                        //   itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          String imgPath =
                              wallpapersList.elementAt(i)['imageUrl'];
                          //   QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          //  if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                      imageUrl: imgPath, //x['imageUrl'],
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                imgPath,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                        // value: loadingProgress
                                        //             .expectedTotalBytes !=
                                        //         null
                                        //     ? loadingProgress
                                        //             .cumulativeBytesLoaded /
                                        //         loadingProgress.expectedTotalBytes
                                        //     : null,
                                        ),
                                  );
                                },
                              ),
                              // CachedNetworkImage(
                              //   placeholder: (context, url) => Container(
                              //     child: Image(
                              //       image: AssetImage('assets/om.png'),
                              //     ),
                              //     // color: Colors.black45,
                              //   ),
                              //
                              //   imageUrl: imgPath, //x['imageUrl'],
                              //   fit: BoxFit.cover,
                              //
                              //   // imageUrl: snapshot.data!.docs
                              //   //     .elementAt(i)['imageUrl'],
                              // ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
  // return Center(
  //     child: CircularProgressIndicator(
  //   color: Colors.red,
  // ));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       // ),
//     );
//   }
}
