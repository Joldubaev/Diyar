import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositoreis/{{name.snakeCase}}_repositoreis.dart';

part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  final {{name.pascalCase()}}Repository repository;
  {{name.pascalCase()}}Cubit(this.repository) : super({{name.pascalCase()}}Initial());
}
