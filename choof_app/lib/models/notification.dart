class Noti {
  String sender;
  String groupName;
  List<String> groupMembers;
  DateTime sentTime;

  Noti(
      {required this.sender,
      required this.groupName,
      required this.groupMembers,
      required this.sentTime});

  factory Noti.fromJson(Map<String, dynamic> json) => Noti(
      sender: json['sender'],
      groupName: json['groupName'],
      groupMembers: json['groupMembers']
          .toString()
          .substring(1, json['tags'].toString().length - 1)
          .split(","),
      sentTime: DateTime.parse(json['sentTime']));

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'groupName': groupName,
        'groupMembers': groupMembers.toString(),
        'sentTime': sentTime.toString()
      };
}
