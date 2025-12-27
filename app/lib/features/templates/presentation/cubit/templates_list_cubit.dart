import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/usecases/create_template_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/delete_template_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/get_templates_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/prepare_delivery_navigation_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'templates_list_state.dart';

/// Cubit для управления состоянием экрана шаблонов
/// Управляет списком шаблонов, выбором шаблона и навигацией
@injectable
class TemplatesListCubit extends Cubit<TemplatesListState> {
  final GetTemplatesUseCase _getTemplates;
  final DeleteTemplateUseCase _deleteTemplateUseCase;
  final PrepareDeliveryNavigationUseCase _prepareNavigationUseCase;
  final CreateTemplateUseCase _createTemplateUseCase;

  // Сохраняем последнее состояние со списком для восстановления после навигации
  TemplatesListLoaded? _lastLoadedState;

  TemplatesListCubit(
    this._getTemplates,
    this._deleteTemplateUseCase,
    this._prepareNavigationUseCase,
    this._createTemplateUseCase,
  ) : super(TemplatesListInitial());

  /// Инициализация экрана - загрузка списка шаблонов
  Future<void> onInit() async {
    await fetch();
  }

  /// Загрузка списка шаблонов
  Future<void> fetch({
    void Function(List<TemplateEntity>)? onSuccess,
    void Function(String)? onError,
  }) async {
    emit(TemplatesListLoading());

    final result = await _getTemplates();
    result.fold(
      (f) {
        emit(TemplatesListFailure(f.message));
        onError?.call(f.message);
      },
      (list) {
        final currentState = state;
        // Сохраняем выбранный шаблон при обновлении списка
        String? selectedId;
        if (currentState is TemplatesListLoaded) {
          selectedId = currentState.selectedTemplateId;
          // Проверяем, что выбранный шаблон все еще существует
          if (selectedId != null && !list.any((t) => t.id == selectedId)) {
            selectedId = null;
          }
        }
        final loadedState = TemplatesListLoaded(list, selectedTemplateId: selectedId);
        _lastLoadedState = loadedState;
        emit(loadedState);
        onSuccess?.call(list);
      },
    );
  }

  /// Выбор шаблона
  void selectTemplate(String? templateId) {
    final currentState = state;
    if (currentState is TemplatesListLoaded) {
      final updatedState = currentState.copyWith(selectedTemplateId: templateId);
      _lastLoadedState = updatedState;
      emit(updatedState);
    }
  }

  /// Применение выбранного шаблона для доставки
  void applySelectedTemplate(
    CartLoaded cartState, {
    void Function(DeliveryNavigationData)? onSuccess,
  }) {
    final currentState = state;
    if (currentState is! TemplatesListLoaded) return;

    final selectedTemplateId = currentState.selectedTemplateId;
    if (selectedTemplateId == null) return;

    final selectedTemplate = currentState.templates.firstWhereOrNull(
      (t) => t.id == selectedTemplateId,
    );

    if (selectedTemplate == null) return;

    final navigationData = _prepareNavigationUseCase.prepareDeliveryWithTemplate(
      template: selectedTemplate,
      cartState: cartState,
    );

    emit(TemplatesNavigationToDeliveryReady(navigationData));
    onSuccess?.call(navigationData);
  }

  /// Пропуск выбора шаблона и переход на карту
  void skipToMap(
    CartLoaded cartState, {
    void Function(OrderMapNavigationData)? onSuccess,
  }) {
    final navigationData = _prepareNavigationUseCase.prepareOrderMap(
      cartState: cartState,
    );

    emit(TemplatesNavigationToOrderMapReady(navigationData));
    onSuccess?.call(navigationData);
  }

  /// Сброс состояния навигации
  void resetNavigation() {
    final currentState = state;
    if (currentState is TemplatesNavigationToDeliveryReady || currentState is TemplatesNavigationToOrderMapReady) {
      // Возвращаемся к последнему состоянию со списком
      if (_lastLoadedState != null) {
        emit(_lastLoadedState!);
      } else {
        // Если нет сохраненного состояния, загружаем список заново
        fetch();
      }
    }
  }

  /// Удаление шаблона
  Future<void> deleteTemplate(
    String templateId, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final currentState = state;
    if (currentState is! TemplatesListLoaded) return;

    final result = await _deleteTemplateUseCase(templateId);
    result.fold(
      (failure) {
        // Эмитим ошибку для показа сообщения
        emit(TemplateDeleteFailure(failure.message));
        // Возвращаемся к исходному состоянию со списком
        emit(currentState);
        onError?.call(failure.message);
      },
      (_) {
        // Удаляем элемент локально
        final updatedList = currentState.templates.where((e) => e.id != templateId).toList();

        // Сбрасываем выбор, если удаленный шаблон был выбран
        final selectedId = currentState.selectedTemplateId == templateId ? null : currentState.selectedTemplateId;

        // Эмитим успех для показа сообщения в listener
        emit(TemplateDeleteSuccess(templateId));

        // Сразу возвращаемся к состоянию со списком для правильного отображения UI
        // Listener успеет обработать TemplateDeleteSuccess между эмитами
        final loadedState = TemplatesListLoaded(updatedList, selectedTemplateId: selectedId);
        _lastLoadedState = loadedState;
        emit(loadedState);
        onSuccess?.call(templateId);
      },
    );
  }

  /// Удаляет шаблон из локального списка без обращения к API
  void removeTemplateById(String id) {
    final current = state;
    if (current is TemplatesListLoaded) {
      final updatedList = current.templates.where((e) => e.id != id).toList();
      final selectedId = current.selectedTemplateId == id ? null : current.selectedTemplateId;
      final loadedState = TemplatesListLoaded(updatedList, selectedTemplateId: selectedId);
      _lastLoadedState = loadedState;
      emit(loadedState);
    }
  }

  /// Создание шаблона из данных заказа
  Future<void> createTemplateFromOrder({
    required String templateName,
    required AddressEntity addressData,
    required ContactInfoEntity contactInfo,
    int? price, // Цена доставки на этот адрес
    void Function()? onSuccess,
    void Function(String)? onError,
  }) async {
    emit(TemplateCreateLoading());

    final template = TemplateEntity(
      id: null,
      templateName: templateName,
      addressData: addressData,
      contactInfo: contactInfo,
      price: price,
    );

    final result = await _createTemplateUseCase(template);
    result.fold(
      (failure) {
        emit(TemplateCreateFailure(failure.message));
        // Возвращаемся к последнему состоянию со списком
        if (_lastLoadedState != null) {
          emit(_lastLoadedState!);
        } else {
          fetch();
        }
        onError?.call(failure.message);
      },
      (_) {
        emit(TemplateCreateSuccess());
        // Обновляем список шаблонов после успешного создания
        fetch();
        onSuccess?.call();
      },
    );
  }
}
