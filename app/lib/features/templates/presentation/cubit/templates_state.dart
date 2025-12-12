part of 'templates_cubit.dart';

sealed class TemplatesState extends Equatable {
  const TemplatesState();

  @override
  List<Object> get props => [];
}

final class TemplatesInitial extends TemplatesState {}

final class TemplatesLoading extends TemplatesState {}

final class TemplatesLoaded extends TemplatesState {
  final List<TemplateEntity> templates;

  const TemplatesLoaded(this.templates);

  @override
  List<Object> get props => [templates];
}

final class TemplateLoaded extends TemplatesState {
  final TemplateEntity template;

  const TemplateLoaded(this.template);

  @override
  List<Object> get props => [template];
}

final class TemplatesError extends TemplatesState {
  final String message;

  const TemplatesError(this.message);

  @override
  List<Object> get props => [message];
}

final class TemplatesCreationSuccess extends TemplatesState {}

final class TemplatesUpdateSuccess extends TemplatesState {}

final class TemplatesDeleteSuccess extends TemplatesState {}
