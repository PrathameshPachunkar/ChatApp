import 'package:chat_app/main.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class searchPage extends StatefulWidget {
  userModel model;
  User user;
  searchPage({super.key, required this.model, required this.user});

  @override
  State<searchPage> createState() => _searchPageState();
}

userModel? searchuser;
DocumentSnapshot? snapshot;
TextEditingController emailController = TextEditingController();

class _searchPageState extends State<searchPage> {
  void searchUser() async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    UserCredential credential = await auth.getRedirectResult();
    String? uid = credential.user!.uid;
    if (uid != null) {
      snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      searchuser = userModel.fromMap(snapshot!.data() as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter Email"),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Submit"),
                onPressed: () {}),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: emailController.text)
                  .where("email", isNotEqualTo: widget.model.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    if (querySnapshot.docs.length > 0) {
                      Map<String, dynamic> userMap =
                          querySnapshot.docs[0].data() as Map<String, dynamic>;

                      userModel? searcherUser = userModel.fromMap(userMap);
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => chatPage(
                                    firebaseUser: widget.user,
                                    targetUser: searcherUser,
                                    model: widget.model,
                                    chatRoom: ,
                                  )));
                        },
                        trailing: Icon(Icons.keyboard_arrow_right),
                        title: Text(searcherUser.fullName!),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searcherUser.profilepic!),
                        ),
                      );
                    } else {
                      return Text("No Result Found!!!");
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        "Error has occured" + snapshot.hasError.toString());
                  } else {
                    return Text("No User Found");
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
