import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiv_wallpaper/new/state.dart';

final firebaseProvider =
    StateNotifierProvider.autoDispose<Firebase, State>((ref) {
  return Firebase(State.empty());
});
// final prov = FutureProvider((ref) => Firebase(List<String>.empty()));

class Firebase extends StateNotifier<State> {

  StreamSubscription<QuerySnapshot>? subscription;

  Firebase(State state) : super(state){
    initialize();
  }

  // List<DocumentSnapshot> wallpaperList =[];

  void initialize() {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("images");
    subscription = collectionReference.snapshots().listen((event) {
      List<DocumentSnapshot> list = [];
      for (var e in event.docs) {
        list.add(e);
      }

      state = state.copyWith(urlList: list, isLoaded: true);
    });
  }
}

// final streamProvider = StreamProvider<List<String>>((ref) async* {
//   final  collectionReference = FirebaseFirestore.instance.collection("images").snapshots();
//   // List<String> list=[];
//   var list = const <String>[];
//      collectionReference.listen((event) {
//     for (var e in event.docs) {
//       // controller.add(e.toString());
//       list.add(e.toString());
//     }
//   }
//   );
//     yield list;
// }
// );

final streamProvider = StreamProvider((ref) {
  return ref.read(streamClassProvider).controller.stream;
});

final streamClassProvider = Provider((ref) {
  return StreamClass();
});

class StreamClass {
  final StreamController<List<DocumentSnapshot?>> controller =
      StreamController();

  StreamClass() {
    initialize();
  }

  initialize() {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("images");
    collectionReference.snapshots().listen((event) {
      List<DocumentSnapshot> list = [];
      for (var e in event.docs) {
        list.add(e);
      }
      print(list);
      controller.add(list);
    });
  }

}
