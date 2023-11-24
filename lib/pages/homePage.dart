import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/searchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  userModel model;
  User firebaseUser;
  homePage({super.key, required this.model, required this.firebaseUser});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CHAT"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => searchPage(
                      model: widget.model, user: widget.firebaseUser)));
        },
        child: Icon(Icons.search),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
