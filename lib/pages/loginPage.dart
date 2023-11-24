import 'dart:developer';

import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/signupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginPage extends StatefulWidget {
  static const String routeName = "loginPage";
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  void valucheck() {
    String email = Email.text.trim();
    String password = Password.text.trim();
    if (email == "" || password == "") {
      print("Enter all fields");
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? Credential;
    try {
      Credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err.code.toString());
    }
    if (Credential != null) {
      String uid = Credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userModel user =
          userModel.fromMap(userData.data() as Map<String, dynamic>);

      log("login Succefull");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              Text(
                "Chat App",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                  controller: Email,
                  decoration: InputDecoration(labelText: "Email Address")),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: Password,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Colors.blue,
                  child: Text("Log In"),
                  onPressed: () {
                    valucheck();
                  }),
            ]),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Don't have a account?"),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => signupPage(),
                    ));
              },
              child: Text(
                "Sign Up",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ))
        ]),
      ),
    );
  }
}
