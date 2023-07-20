import 'package:cloud_firestore/cloud_firestore.dart';

class State {
  bool? isLoaded;
  List<DocumentSnapshot> ? urlList;

  State(
      this.isLoaded,
      this.urlList,
      );

  factory State.empty() {
    return State(
      false,
      null,
    );
  }
  State copyWith({
    bool? isLoaded,
    List<DocumentSnapshot> ? urlList,
  }) {
    return State(isLoaded ?? this.isLoaded, urlList ?? this.urlList,);
  }
}