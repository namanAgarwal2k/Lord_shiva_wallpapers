import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import 'appDrawer.dart';
import 'firebase.dart';
import 'fullscreen.dart';

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
                  })
            ]),
        drawer: AppDrawer(),
        body: watchState.when(
          data: (data) {
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                String imgPath = data[index]!['imageUrl'];
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
