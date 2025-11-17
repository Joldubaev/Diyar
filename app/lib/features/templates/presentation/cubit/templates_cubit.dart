import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'templates_state.dart';

@injectable
class TemplatesCubit extends Cubit<TemplatesState> {
  TemplatesCubit() : super(TemplatesInitial());
}
