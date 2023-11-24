import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/completeProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class signupPage extends StatefulWidget {
  static const String routeName = "signUpPage";
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  void valuecheck() {
    String Email = email.text.trim();
    String Password = password.text.trim();
    String Cpassword = cpassword.text.trim();

    if (Email == "" || Password == "" || Cpassword == "") {
      print("Enter all fields");
    }
    if (Password != Cpassword) {
      print("Confirm password does not match");
    }
  }

  void firebaseSignIn(String email, String password) async {
    UserCredential? Credential;
    try {
      Credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (err) {
      print(err.code.toString());
    }
    if (Credential != null) {
      String uid = Credential.user!.uid;
      userModel user = userModel(
        uid: uid,
        email: email,
        profilepic: "",
        fullName: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(user.toMap())
          .then((value) {
        print("New User Created");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => completeProfilePage(
                    model: user, firebaseUser: Credential!.user!)));
      });
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
                  controller: email,
                  decoration: InputDecoration(labelText: "Email Address")),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: cpassword,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Colors.blue,
                  child: Text("Sign In"),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => completeProfilePage()));
                    valuecheck();
                    firebaseSignIn(email.text.trim(), password.text.trim());
                  }),
            ]),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(" Already have a account?"),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "log In",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ))
        ]),
      ),
    );
  }
}
