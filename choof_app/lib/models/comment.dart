class Comment {
  String? docId;
  String postName;
  String postLink;
  String postCreator;
  String postGroup;
  String commenter;
  String commenterUrl;
  String commentText;
  DateTime addedTime;

  Comment({
    this.docId,
    required this.postName,
    required this.postLink,
    required this.postCreator,
    required this.postGroup,
    required this.commenter,
    required this.commenterUrl,
    required this.commentText,
    required this.addedTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        docId: json['docId'] ?? '',
        postName: json['postName'],
        postLink: json['postLink'],
        postCreator: json['postCreator'],
        postGroup: json['postGroup'],
        commenter: json['commenter'],
        commenterUrl: json['commenterUrl'],
        commentText: json['commentText'],
        addedTime: DateTime.parse(json['addedTime']),
      );

  Map<String, dynamic> toJson() => {
        'docId': docId ?? '',
        'postName': postName,
        'postLink': postLink,
        'postCreator': postCreator,
        'postGroup': postGroup,
        'commenter': commenter,
        'commenterUrl': commenterUrl,
        'commentText': commentText,
        'addedTime': addedTime.toString(),
      };
}
