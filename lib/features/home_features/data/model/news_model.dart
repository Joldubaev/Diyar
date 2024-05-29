class NewsModel {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;

  NewsModel({
    this.id,
    this.name,
    this.description,
    this.photoLink,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoLink: json["photoLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoLink": photoLink,
      };
}
