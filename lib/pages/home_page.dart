import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:blog_flutter/pages/create_blog.dart';
import 'package:blog_flutter/services/FirestoreCrud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreCrud firestoreCrudRef = new FirestoreCrud();
  Stream<QuerySnapshot> blogsSnapShot;

  @override
  void initState() {
    firestoreCrudRef.readData().then((result) {
      blogsSnapShot = result;
    });
    super.initState();
  }

  Widget blogList() {
    return Container(
      child: StreamBuilder(
          stream: blogsSnapShot,
          builder: (context, snapshot) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              padding: EdgeInsets.only(top: 24),
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var blogs = snapshot.data.docs[index].data();
                return BlogTile(
                  author: blogs['author'] ?? " ",
                  title: blogs['tile'] ?? " ",
                  body: blogs['body'] ?? " ",
                  imageUrl: blogs['imageUrl'] ?? " ",
                );
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Flutter', style: TextStyle(fontSize: 25)),
              Text(
                'Blog',
                style: TextStyle(color: Colors.blue, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      body: blogList(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBlog(),
                  ));
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl;
  final String author;
  final String title;
  final String body;
  const BlogTile({
    Key key,
    this.imageUrl,
    this.author,
    this.title,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  body,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  author,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
