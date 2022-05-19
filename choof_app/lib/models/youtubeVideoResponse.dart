class YoutubeVideoResponse {
  String? kind;
  String? etag;
  List<Items>? items;
  PageInfo? pageInfo;

  YoutubeVideoResponse({this.kind, this.etag, this.items, this.pageInfo});

  YoutubeVideoResponse.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    pageInfo =
        json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      data['pageInfo'] = pageInfo!.toJson();
    }
    return data;
  }
}

class Items {
  String? kind;
  String? etag;
  String? id;
  Snippet? snippet;

  Items({this.kind, this.etag, this.id, this.snippet});

  Items.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = json['id'];
    snippet =
        json['snippet'] != null ? Snippet.fromJson(json['snippet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    data['id'] = id;
    if (snippet != null) {
      data['snippet'] = snippet!.toJson();
    }
    return data;
  }
}

class Snippet {
  String? publishedAt;
  String? channelId;
  String? title;
  String? description;
  Thumbnails? thumbnails;
  String? channelTitle;
  List<String>? tags;
  String? categoryId;
  String? liveBroadcastContent;
  String? defaultLanguage;
  Localized? localized;
  String? defaultAudioLanguage;

  Snippet(
      {this.publishedAt,
      this.channelId,
      this.title,
      this.description,
      this.thumbnails,
      this.channelTitle,
      this.tags,
      this.categoryId,
      this.liveBroadcastContent,
      this.defaultLanguage,
      this.localized,
      this.defaultAudioLanguage});

  Snippet.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    title = json['title'];
    description = json['description'];
    thumbnails = json['thumbnails'] != null
        ? Thumbnails.fromJson(json['thumbnails'])
        : null;
    channelTitle = json['channelTitle'];
    categoryId = json['categoryId'];
    liveBroadcastContent = json['liveBroadcastContent'];
    defaultLanguage = json['defaultLanguage'];
    localized = json['localized'] != null
        ? Localized.fromJson(json['localized'])
        : null;
    defaultAudioLanguage = json['defaultAudioLanguage'];
    tags = json['tags']
        .toString()
        .substring(1, json['tags'].toString().length - 1)
        .split(",");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publishedAt'] = publishedAt;
    data['channelId'] = channelId;
    data['title'] = title;
    data['description'] = description;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.toJson();
    }
    data['channelTitle'] = channelTitle;
    data['categoryId'] = categoryId;
    data['liveBroadcastContent'] = liveBroadcastContent;
    data['defaultLanguage'] = defaultLanguage;
    if (localized != null) {
      data['localized'] = localized!.toJson();
    }
    data['defaultAudioLanguage'] = defaultAudioLanguage;
    data['tags'] = tags.toString();
    return data;
  }
}

class Thumbnails {
  Quality? defaultQ;
  Quality? medium;
  Quality? high;

  Thumbnails({this.defaultQ, this.medium, this.high});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    defaultQ =
        json['default'] != null ? Quality.fromJson(json['default']) : null;
    medium = json['medium'] != null ? Quality.fromJson(json['medium']) : null;
    high = json['high'] != null ? Quality.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (defaultQ != null) {
      data['default'] = defaultQ!.toJson();
    }
    if (medium != null) {
      data['medium'] = medium!.toJson();
    }
    if (high != null) {
      data['high'] = high!.toJson();
    }
    return data;
  }
}

class Quality {
  String? url;
  int? width;
  int? height;

  Quality({this.url, this.width, this.height});

  Quality.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class Localized {
  String? title;
  String? description;

  Localized({this.title, this.description});

  Localized.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class PageInfo {
  int? totalResults;
  int? resultsPerPage;

  PageInfo({this.totalResults, this.resultsPerPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['totalResults'];
    resultsPerPage = json['resultsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalResults'] = totalResults;
    data['resultsPerPage'] = resultsPerPage;
    return data;
  }
}
