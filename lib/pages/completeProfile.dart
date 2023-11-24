import 'dart:io';

import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class completeProfilePage extends StatefulWidget {
  static const String routeName = "CompleteProfilePage";
  final userModel model;
  final User firebaseUser;
  const completeProfilePage(
      {super.key, required this.model, required this.firebaseUser});

  @override
  State<completeProfilePage> createState() => _completeProfilePageState();
}

class _completeProfilePageState extends State<completeProfilePage> {
  TextEditingController fullName = TextEditingController();
  @override
  File? imageFile;
  void selectImage(ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      cropImage(file);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropImage = await ImageCropper().cropImage(
        compressQuality: 20,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: file.path);
    if (cropImage != null) {
      setState(() {
        imageFile = File(cropImage.path);
      });
    }
  }

  void showAlerBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Photo From Gallery"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () =>
                      {Navigator.pop(context), selectImage(ImageSource.camera)},
                  leading: Icon(Icons.camera_alt),
                  title: Text("Add Profile from Camera"),
                ),
                ListTile(
                  onTap: () => {
                    Navigator.pop(context),
                    selectImage(ImageSource.gallery)
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Add Photo from Gallery"),
                )
              ],
            ),
          );
        });
  }

  void checkvalue() {
    String name = fullName.text.trim();
    if (name == "" || imageFile == null) {
      AlertDialog(
        title: Text("complete the profile"),
      );
    } else {
      saveData();
    }
  }

  void saveData() async {
    UploadTask task = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.model!.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await task;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String FullName = fullName.text.trim();
    widget.model.fullName = FullName;
    widget.model.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.model.uid)
        .set(widget.model.toMap());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Complete Profile",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null) ? Icon(Icons.person) : null,
                  ),
                  onPressed: () {
                    showAlerBox();
                  }),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: fullName,
                decoration: InputDecoration(labelText: "Enter Full Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                  color: Colors.blue,
                  child: Text("Submit"),
                  onPressed: () {
                    checkvalue();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => homePage(
                                  model: widget.model,
                                  firebaseUser: widget.firebaseUser,
                                )));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
