class Post {
  String? docId;
  String name;
  String youtubeLink;
  String? thumbnailUrl;
  List<String> tags;
  String creator;
  String creatorImageUrl;
  String groupName;
  DateTime addedTime;
  int? controllerIndex;
  bool? isReported;

  Post(
      {this.docId,
      required this.name,
      required this.youtubeLink,
      this.thumbnailUrl,
      required this.tags,
      required this.groupName,
      required this.creator,
      required this.creatorImageUrl,
      required this.addedTime,
      this.controllerIndex,
      this.isReported});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        docId: json['docId'] ?? '',
        name: json['name'],
        youtubeLink: json['youtubeLink'],
        thumbnailUrl: json['thumbnailUrl'],
        tags: json['tags']
            .toString()
            .substring(1, json['tags'].toString().length - 1)
            .split(","),
        groupName: json['groupName'],
        creator: json['creator'],
        creatorImageUrl: json['creatorImageUrl'],
        addedTime: DateTime.parse(json['addedTime']),
        isReported: json['isReported'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'docId': docId ?? '',
        'name': name,
        'youtubeLink': youtubeLink,
        'thumbnailUrl': thumbnailUrl,
        'tags': tags.toString(),
        'groupName': groupName,
        'creator': creator,
        'creatorImageUrl': creatorImageUrl,
        'addedTime': addedTime.toString(),
        'isReported': isReported,
      };
}
