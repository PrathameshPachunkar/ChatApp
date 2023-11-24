class messageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  messageModel({this.createdon, this.seen, this.sender, this.text});
  messageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"];
  }
  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "seen": seen,
      "createdon": createdon,
      "text": text
    };
  }
}
