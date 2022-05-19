class Group {
  String? docId;
  String name;
  List<String> tags;
  String owner;
  String ownerImageUrl;
  List<String> members;
  DateTime lastUpdatedTime;
  DateTime createdTime;
  int? videoNumber;

  Group(
      {this.docId,
      required this.name,
      required this.tags,
      required this.owner,
      required this.ownerImageUrl,
      required this.members,
      required this.lastUpdatedTime,
      required this.createdTime,
      this.videoNumber});

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        docId: json['docId'] ?? '',
        name: json['name'],
        tags: json['tags']
            .toString()
            .substring(1, json['tags'].toString().length - 1)
            .split(","),
        owner: json['owner'],
        ownerImageUrl: json['ownerImageUrl'],
        members: json['members']
            .toString()
            .substring(1, json['members'].toString().length - 1)
            .split(","),
        lastUpdatedTime: DateTime.parse(json['lastUpdatedTime']),
        createdTime: DateTime.parse(json['createdTime']),
      );

  Map<String, dynamic> toJson() => {
        'docId': docId ?? '',
        'name': name,
        'tags': tags.toString(),
        'owner': owner,
        'ownerImageUrl': ownerImageUrl,
        'members': members.toString(),
        'lastUpdatedTime': lastUpdatedTime.toString(),
        'createdTime': createdTime.toString(),
      };
}
