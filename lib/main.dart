import 'package:chat_app/models/firebaseHelper.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/completeProfile.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    userModel? model = await FirebaseHelper.fetchuserdata(user.uid);
    if (model != null) {
      runApp(loggedIn(
        user: user,
        model: model!,
      ));
    } else {
      runApp(const chatApp());
    }
  } else {
    runApp(const chatApp());
  }
}

class chatApp extends StatelessWidget {
  const chatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}

class loggedIn extends StatelessWidget {
  userModel model;
  User user;
  loggedIn({super.key, required this.model, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(
        firebaseUser: user,
        model: model,
      ),
    );
  }
}
