import 'package:dio/dio.dart';
import '../../domain/repositoreis/{{name.snakeCase}}_repositoreis.dart';



class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository{
  final Dio dio;

  {{name.pascalCase()}}RepositoryImpl(this.dio);
}