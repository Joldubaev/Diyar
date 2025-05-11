
import 'package:diyar/injection_container.dart';

import 'data/repository/{{name.snakeCase()}}_repository.dart';
import 'domain/repositoreis/{{name.snakeCase()}}_repositories.dart';
import 'presentation/cubit/{{name.snakeCase()}}_cubit.dart';

{{name.camelCase()}}Injection() {
  // REPOSITORIES
  sl.registerSingleton<{{name.pascalCase()}}Repository>({{name.pascalCase()}}RepositoryImpl(sl()));

  // BLOC
  sl.registerLazySingleton(() => {{name.pascalCase()}}Cubit(sl()));
}
