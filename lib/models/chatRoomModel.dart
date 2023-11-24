class chatRoomModel {
  String? chatRoomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  chatRoomModel({this.chatRoomid, this.participants, this.lastMessage});

  chatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomid = map["chatRoomid"];
    participants = map[" participants"];
    lastMessage = map["lastmessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomid": chatRoomid,
      "participants": participants,
      "lastmessage": lastMessage
    };
  }
}
