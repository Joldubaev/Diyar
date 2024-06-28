import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'templates_state.dart';

class TemplatesCubit extends Cubit<TemplatesState> {
  TemplatesCubit() : super(TemplatesInitial());
}
