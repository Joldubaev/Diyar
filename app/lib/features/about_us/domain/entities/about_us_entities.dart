class AboutUsEntities {
  final String name;
  final String description;
  final List? photoLinks;

  AboutUsEntities({
    required this.name,
    required this.description,
    required this.photoLinks,
  });

  AboutUsEntities copyWith({
    String? name,
    String? description,
    List? photoLinks,
  }) {
    return AboutUsEntities(
      name: name ?? this.name,
      description: description ?? this.description,
      photoLinks: photoLinks ?? this.photoLinks,
    );
  }
}
