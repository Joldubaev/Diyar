part of 'templates_list_cubit.dart';

sealed class TemplatesListState extends Equatable {
  const TemplatesListState();

  @override
  List<Object?> get props => [];
}

final class TemplatesListInitial extends TemplatesListState {}

final class TemplatesListLoading extends TemplatesListState {}

final class TemplatesListLoaded extends TemplatesListState {
  final List<TemplateEntity> templates;
  final String? selectedTemplateId;

  const TemplatesListLoaded(
    this.templates, {
    this.selectedTemplateId,
  });

  TemplatesListLoaded copyWith({
    List<TemplateEntity>? templates,
    String? selectedTemplateId,
  }) {
    return TemplatesListLoaded(
      templates ?? this.templates,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
    );
  }

  @override
  List<Object?> get props => [templates, selectedTemplateId];
}

final class TemplatesListFailure extends TemplatesListState {
  final String message;

  const TemplatesListFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class TemplateDeleteSuccess extends TemplatesListState {
  final String templateId;

  const TemplateDeleteSuccess(this.templateId);

  @override
  List<Object?> get props => [templateId];
}

final class TemplateDeleteFailure extends TemplatesListState {
  final String message;

  const TemplateDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class TemplatesNavigationToDeliveryReady extends TemplatesListState {
  final DeliveryNavigationData navigationData;

  const TemplatesNavigationToDeliveryReady(this.navigationData);

  @override
  List<Object?> get props => [navigationData];
}

final class TemplatesNavigationToOrderMapReady extends TemplatesListState {
  final OrderMapNavigationData navigationData;

  const TemplatesNavigationToOrderMapReady(this.navigationData);

  @override
  List<Object?> get props => [navigationData];
}

final class TemplateCreateLoading extends TemplatesListState {}

final class TemplateCreateSuccess extends TemplatesListState {}

final class TemplateCreateFailure extends TemplatesListState {
  final String message;

  const TemplateCreateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
