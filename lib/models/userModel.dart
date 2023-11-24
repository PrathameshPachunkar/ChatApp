class userModel {
  String? uid;
  String? fullName;
  String? email;
  String? profilepic;
  userModel({this.email, this.fullName, this.profilepic, this.uid});
  userModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    email = map["email"];
    fullName = map["fullName"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "fullName": fullName,
      "profilepic": profilepic,
    };
  }
}
