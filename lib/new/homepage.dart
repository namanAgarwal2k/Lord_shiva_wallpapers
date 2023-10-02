import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import 'appDrawer.dart';
import 'firebase.dart';
import 'fullscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final watchState = ref.watch(firebaseProvider);
    final watchState = ref.watch(streamProvider);

    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 50,
            title: const Center(
              child: Text(
                'Jai BholeNath',
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

              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   childAspectRatio: 0.7,
              //   crossAxisSpacing: 1.0,
              //   mainAxisSpacing: 1.0,
              // ),
              staggeredTileBuilder: (int index) {
                if (index % 40 == 0 && index != 0) {
                  // Set the ad tile to span two columns and one row
                  return StaggeredTile.count(2, 1);
                } else {
                  // Set the grid item tile to span one column and one row
                  return StaggeredTile.count(1, 1.6);
                }
              },
              itemBuilder: (context, index) {
                String imgPath = data[index]!['imageUrl'];
                // if (index % 40 == 0 && index != 0) {
                //   // Insert ad widget after every fifth item
                //   return Container(
                //     height: 30,
                //     color: Colors.green,
                //   );
                // } else {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Fullscreen(
                                  url: imgPath,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 400,
                        maxWidthDiskCache: 280,
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
                // }
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
