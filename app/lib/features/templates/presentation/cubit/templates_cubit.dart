import 'package:bloc/bloc.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/domain/usecases/create_template_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/delete_template_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/get_template_by_id_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/get_templates_usecase.dart';
import 'package:diyar/features/templates/domain/usecases/update_template_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'templates_state.dart';

@injectable
class TemplatesCubit extends Cubit<TemplatesState> {
  final GetTemplatesUseCase _getTemplatesUseCase;
  final GetTemplateByIdUseCase _getTemplateByIdUseCase;
  final CreateTemplateUseCase _createTemplateUseCase;
  final UpdateTemplateUseCase _updateTemplateUseCase;
  final DeleteTemplateUseCase _deleteTemplateUseCase;

  TemplatesCubit(
    this._getTemplatesUseCase,
    this._getTemplateByIdUseCase,
    this._createTemplateUseCase,
    this._updateTemplateUseCase,
    this._deleteTemplateUseCase,
  ) : super(TemplatesInitial());

  Future<void> fetchTemplates() async {
    emit(TemplatesLoading());
    final result = await _getTemplatesUseCase();
    result.fold(
      (failure) => emit(TemplatesError(failure.message)),
      (templates) => emit(TemplatesLoaded(templates)),
    );
  }

  Future<void> fetchTemplateById(String templateId) async {
    emit(TemplatesLoading());
    final result = await _getTemplateByIdUseCase(templateId);
    result.fold(
      (failure) => emit(TemplatesError(failure.message)),
      (template) => emit(TemplateLoaded(template)),
    );
  }

  Future<void> saveTemplate(TemplateEntity template) async {
    emit(TemplatesLoading());
    final result = await _createTemplateUseCase(template);
    result.fold(
      (failure) => emit(TemplatesError(failure.message)),
      (_) {
        emit(TemplatesCreationSuccess());
        fetchTemplates(); // Обновляем список после создания
      },
    );
  }

  Future<void> updateTemplate(TemplateEntity template) async {
    emit(TemplatesLoading());
    final result = await _updateTemplateUseCase(template);
    result.fold(
      (failure) => emit(TemplatesError(failure.message)),
      (_) {
        emit(TemplatesUpdateSuccess());
        fetchTemplates(); // Обновляем список после обновления
      },
    );
  }

  Future<void> deleteTemplate(String templateId) async {
    emit(TemplatesLoading());
    final result = await _deleteTemplateUseCase(templateId);
    result.fold(
      (failure) => emit(TemplatesError(failure.message)),
      (_) {
        emit(TemplatesDeleteSuccess());
        fetchTemplates(); // Обновляем список после удаления
      },
    );
  }
}
