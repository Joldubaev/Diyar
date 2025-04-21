import 'package:diyar/features/menu/domain/domain.dart';

class MessagModel {
  final String? id;
  final String? name;

  MessagModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory MessagModel.fromJson(Map<String, dynamic> map) {
    return MessagModel(
      id: map['id'],
      name: map['name'],
    );
  }

 factory MessagModel.fromEntity(MessageEntity entity) {
    return MessagModel(
      id: entity.id,
      name: entity.name,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      name: name,
    );
  }
}
