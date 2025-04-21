import 'message_entity.dart';

class CategoryEntity {
  final int? code;
  final List<MessageEntity>? message;
  CategoryEntity({
    this.code,
    this.message,
  });
  CategoryEntity copyWith({
    int? code,
    List<MessageEntity>? message,
  }) =>
      CategoryEntity(
        code: code ?? this.code,
        message: message ?? this.message,
      );
}
