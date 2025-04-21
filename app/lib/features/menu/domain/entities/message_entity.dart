import 'package:flutter/widgets.dart';

class MessageEntity {
  final String? id;
  final String? name;

  MessageEntity({
    this.id,
    this.name,
  });

  MessageEntity copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
  }) {
    return MessageEntity(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
    );
  }
}
