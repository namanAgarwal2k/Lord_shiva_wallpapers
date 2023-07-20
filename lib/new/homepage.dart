import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase.dart';
class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final watchState = ref.watch(firebaseProvider);
    final watchState = ref.watch(streamProvider);

    return Scaffold(
        body:
            watchState.when(
      data: (data) {
        return GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            String imgPath = data[index]!['imageUrl'];
            return InkWell(
              onTap: () {
                context.go('/fullscreen', extra: imgPath);
              },
              child: CachedNetworkImage(
                maxHeightDiskCache: 256,
                maxWidthDiskCache: 256,
                fit: BoxFit.cover,
                imageUrl: imgPath,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: Padding(
                    padding: const EdgeInsets.all(58.0),
                    child: LinearProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
