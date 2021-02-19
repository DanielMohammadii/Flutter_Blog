import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCrud {
  CollectionReference blogs = FirebaseFirestore.instance.collection('blogs');

  Future<void> addBlog(addData) async {
    blogs
        .add(addData)
        .then((value) => print(value))
        .catchError((error) => print("Failed to add user: $error"));
  }

  readData() async {
    return await blogs.snapshots();
  }
}
