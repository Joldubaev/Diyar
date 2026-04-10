import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/repository/template_repository.dart';
import 'package:diyar/features/templates/domain/usecases/prepare_delivery_navigation_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'templates_list_state.dart';

@injectable
class TemplatesListCubit extends Cubit<TemplatesListState> {
  final TemplateRepository _repository;
  final PrepareDeliveryNavigationUseCase _prepareNavigationUseCase;

  TemplatesListLoaded? _lastLoadedState;

  TemplatesListCubit(
    this._repository,
    this._prepareNavigationUseCase,
  ) : super(TemplatesListInitial());

  Future<void> onInit() async => fetch();

  Future<void> fetch() async {
    emit(TemplatesListLoading());

    final result = await _repository.getAllTemplates();
    result.fold(
      (f) => emit(TemplatesListFailure(f.message)),
      (list) {
        final currentState = state;
        String? selectedId;
        if (currentState is TemplatesListLoaded) {
          selectedId = currentState.selectedTemplateId;
          if (selectedId != null && !list.any((t) => t.id == selectedId)) {
            selectedId = null;
          }
        }
        final loadedState =
            TemplatesListLoaded(list, selectedTemplateId: selectedId);
        _lastLoadedState = loadedState;
        emit(loadedState);
      },
    );
  }

  void selectTemplate(String? templateId) {
    final currentState = state;
    if (currentState is TemplatesListLoaded) {
      final updated =
          currentState.copyWith(selectedTemplateId: templateId);
      _lastLoadedState = updated;
      emit(updated);
    }
  }

  void applySelectedTemplate(CartLoaded cartState) {
    final currentState = state;
    if (currentState is! TemplatesListLoaded) return;

    final selectedTemplateId = currentState.selectedTemplateId;
    if (selectedTemplateId == null) return;

    final selectedTemplate = currentState.templates.firstWhereOrNull(
      (t) => t.id == selectedTemplateId,
    );
    if (selectedTemplate == null) return;

    final navigationData =
        _prepareNavigationUseCase.prepareDeliveryWithTemplate(
      template: selectedTemplate,
      cartState: cartState,
    );
    emit(TemplatesNavigationToDeliveryReady(navigationData));
  }

  void skipToMap(CartLoaded cartState) {
    final navigationData = _prepareNavigationUseCase.prepareOrderMap(
      cartState: cartState,
    );
    emit(TemplatesNavigationToOrderMapReady(navigationData));
  }

  void resetNavigation() {
    final currentState = state;
    if (currentState is TemplatesNavigationToDeliveryReady ||
        currentState is TemplatesNavigationToOrderMapReady) {
      if (_lastLoadedState != null) {
        emit(_lastLoadedState!);
      } else {
        fetch();
      }
    }
  }

  Future<void> deleteTemplate(String templateId) async {
    final currentState = state;
    if (currentState is! TemplatesListLoaded) return;

    final result = await _repository.deleteTemplate(templateId);
    result.fold(
      (failure) {
        emit(TemplateDeleteFailure(failure.message));
        emit(currentState);
      },
      (_) {
        final updatedList =
            currentState.templates.where((e) => e.id != templateId).toList();
        final selectedId = currentState.selectedTemplateId == templateId
            ? null
            : currentState.selectedTemplateId;
        emit(TemplateDeleteSuccess(templateId));
        final loadedState =
            TemplatesListLoaded(updatedList, selectedTemplateId: selectedId);
        _lastLoadedState = loadedState;
        emit(loadedState);
      },
    );
  }

  void removeTemplateById(String id) {
    final current = state;
    if (current is TemplatesListLoaded) {
      final updatedList = current.templates.where((e) => e.id != id).toList();
      final selectedId =
          current.selectedTemplateId == id ? null : current.selectedTemplateId;
      final loadedState =
          TemplatesListLoaded(updatedList, selectedTemplateId: selectedId);
      _lastLoadedState = loadedState;
      emit(loadedState);
    }
  }

  Future<void> createTemplateFromOrder({
    required String templateName,
    required AddressEntity addressData,
    required ContactInfoEntity contactInfo,
    int? price,
  }) async {
    emit(TemplateCreateLoading());

    final template = TemplateEntity(
      id: null,
      templateName: templateName,
      addressData: addressData,
      contactInfo: contactInfo,
      price: price,
    );

    final result = await _repository.createTemplate(template);
    result.fold(
      (failure) {
        emit(TemplateCreateFailure(failure.message));
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        } else {
          fetch();
        }
      },
      (_) {
        emit(TemplateCreateSuccess());
        fetch();
      },
    );
  }
}
