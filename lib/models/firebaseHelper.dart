import 'package:chat_app/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<userModel?> fetchuserdata(String uid) async {
    userModel? model;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (documentSnapshot != null) {
      model =
          userModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return model;
  }
}
