import 'dart:io';
import 'package:blog_flutter/services/FirestoreCrud.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  FirestoreCrud firestoreCrudRef = FirestoreCrud();
  File selectedImage;
  final picker = ImagePicker();
  bool _isloading = false;
  TextEditingController authorTextEditingControllercontroller =
      new TextEditingController();
  TextEditingController titleTextEditingControllercontroller =
      new TextEditingController();
  TextEditingController bodyTextEditingControllercontroller =
      new TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadBlog() async {
    setState(() {
      _isloading = true;
    });
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child("${randomAlphaNumeric(10)}.jpg");

    final firebase_storage.UploadTask task = ref.putFile(selectedImage);

    var imageUrl;
    await task.whenComplete(() async {
      try {
        imageUrl = await ref.getDownloadURL();
      } catch (onError) {
        print("Error");
      }
    });

    Map<String, dynamic> blogData = {
      'author': authorTextEditingControllercontroller.text,
      'title': titleTextEditingControllercontroller.text,
      'body': bodyTextEditingControllercontroller.text,
      'imageUrl': imageUrl,
    };
    Navigator.pop(context);

    firestoreCrudRef.addBlog(blogData).then((value) {
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text('What Is In Your Mind'),
      ),
      body: _isloading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: authorTextEditingControllercontroller,
                        decoration: InputDecoration(
                          hintText: 'Author',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: titleTextEditingControllercontroller,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: bodyTextEditingControllercontroller,
                        decoration: InputDecoration(
                          hintText: 'Body',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    uploadBlog();
                  },
                )
              ],
            ),
    );
  }
}
