class Profile {
  String? docId;
  String name;
  String? userUid;
  String email;
  String imageUrl;
  bool allowNotifications;
  bool isInvited;
  List<String>? blockedUsers;
  List<String>? blockByUsers;

  Profile(
      {this.docId,
      required this.name,
      this.userUid,
      required this.email,
      required this.imageUrl,
      required this.allowNotifications,
      required this.isInvited,
      this.blockedUsers,
      this.blockByUsers});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        docId: json['docId'] ?? '',
        name: json['name'],
        email: json['email'] ?? '',
        imageUrl: json['imageUrl'],
        allowNotifications: json['allowNotifications'],
        isInvited: json['isInvited'],
        blockedUsers: json['blockedUsers'] != null
            ? json['blockedUsers']
                .toString()
                .substring(1, json['blockedUsers'].toString().length - 1)
                .split(",")
            : [],
        blockByUsers: json['blockByUsers'] != null
            ? json['blockByUsers']
                .toString()
                .substring(1, json['blockByUsers'].toString().length - 1)
                .split(",")
            : [],
      );

  Map<String, dynamic> toJson() => {
        'docId': docId ?? '',
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'allowNotifications': allowNotifications,
        'isInvited': isInvited,
        'blockedUsers': blockedUsers.toString(),
        'blockByUsers': blockByUsers.toString(),
      };
}
