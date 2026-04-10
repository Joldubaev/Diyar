import 'package:equatable/equatable.dart';

class AboutUsEntity extends Equatable {
  final String name;
  final String description;
  final List<String> photoLinks;

  const AboutUsEntity({
    required this.name,
    required this.description,
    required this.photoLinks,
  });

  @override
  List<Object?> get props => [name, description, photoLinks];
}

/// Backward compatibility alias
typedef AboutUsEntities = AboutUsEntity;
