class HashGroup {
  String imageurl;
  String name;

  List<TagTitle> tagTitle;

  HashGroup({this.imageurl, this.name, this.tagTitle});

  factory HashGroup.fromJson(Map<String, dynamic> json) {
    return HashGroup(
      imageurl: json["image_url"] as String,
      name: json["name"] as String,
      tagTitle: parseTagTitle(json),
    );
  }

  static List<TagTitle> parseTagTitle(tagTitles) {
    var list = tagTitles['tags_cat'] as List;
    List<TagTitle> tagTiles =
        list.map((data) => TagTitle.fromJson(data)).toList();
    return tagTiles;
  }

}

class TagTitle {
  List<String> tags;
  String name;

  TagTitle({this.tags, this.name});

  factory TagTitle.fromJson(Map<String, dynamic> json) {
    return TagTitle(
      tags: getTags(json["tags"]),
      name: json["name"] as String,
    );
  }

  static List<String> getTags(json) {
    List<String> list = new List<String>.from(json);
    return list;
  }
}
