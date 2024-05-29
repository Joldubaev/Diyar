class AboutUsModel {
  AboutUsModel({
    this.name,
    this.description,
    this.photoLinks,
  });

  final String? name;
  final String? description;
  final List? photoLinks;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        name: json['name'],
        description: json['description'],
        photoLinks: json['photoLinks'] == null ? null : List.from(json['photoLinks']).map((x) => x).toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'photoLinks': photoLinks == null ? null : List<dynamic>.from(photoLinks!.map((x) => x.toJson())),
      };
}
