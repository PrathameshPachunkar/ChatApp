import 'package:chat_app/models/chatRoomModel.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/pages/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  final userModel targetUser;
  final User firebaseUser;
  final userModel model;
  final chatRoomModel chatRoom;
   chatPage({super.key,required this.chatRoom,required this.firebaseUser,required this.model,required this.targetUser});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: SafeArea(
          child: Container(
        child: Column(children: [
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            color: Colors.grey[200],
            child: Row(
              children: [
                Flexible(
                    child: chatTextField(
                  controller: messageController,
                )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
                    ))
              ],
            ),
          )
        ]),
      )),
    );
  }
}
