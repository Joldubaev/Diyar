# CLAUDE.md — Diyar Flutter Project

Этот файл описывает архитектуру проекта для AI-ассистентов (Claude, Cursor, Copilot).
Строго следуй правилам при генерации кода.

---

## 1. Обзор

Flutter food-delivery приложение. Monorepo под управлением **Melos** + **FVM**.

- Flutter: `3.27.0` (через FVM — всегда используй `fvm flutter`, не `flutter` напрямую)
- Dart: `>=3.3.3 <4.0.0`
- Главное приложение: `app/`
- Общие пакеты: `packages/`

### Пакеты в `packages/`

| Пакет | Назначение |
|---|---|
| `network` | HTTP-клиент (Dio), интерцепторы, ошибки сети |
| `storage` | SecureStorage, SharedPreferences, HiveStorage |
| `geo` | Зоны доставки, геометрические утилиты |
| `rest_client` | Обёртка REST-клиента (legacy, совместимость) |
| `signalr_client` | SignalR real-time (отслеживание курьера, статус заказа) |
| `ui_kit` | Общие UI-компоненты, цвета, типографика |

---

## 2. Стек технологий

| Аспект | Инструмент |
|---|---|
| State management | `flutter_bloc` — Cubit (простое) / BLoC (события) |
| DI | `get_it` + `injectable` (кодогенерация) |
| Ошибки | `fpdart` — `Either<Failure, T>`. **НЕ** `dartz`/`Either` из других пакетов |
| Навигация | `auto_route` с guards |
| HTTP | `dio` (внутри `network` пакета) |
| Локальное хранилище | Hive (корзина, кэш), SharedPreferences (настройки), flutter_secure_storage (токены) |
| Кодогенерация | `freezed`, `json_serializable`, `auto_route_generator`, `injectable_generator` |
| Запуск кодогенерации | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |
| Тесты | `flutter_test`, `mocktail` |
| Real-time | SignalR через `signalr_client` пакет |
| Карта | Yandex MapKit (`yandex_mapkit`) |

---

## 3. Структура фичи

Каждая фича живёт в `app/lib/features/<name>/` с разделением на слои:

```
app/lib/features/<name>/
├── <name>.dart                          ← barrel export фичи
├── data/
│   ├── data.dart
│   ├── datasources/
│   │   ├── remote/<name>_remote_data_source.dart   ← abstract + Impl
│   │   └── local/<name>_local_data_source.dart     ← если нужен кэш
│   ├── models/
│   │   ├── <entity>_model.dart          ← @freezed, JSON serializable
│   │   ├── <entity>_model.freezed.dart  ← сгенерировано
│   │   └── <entity>_model.g.dart        ← сгенерировано
│   └── repositories/
│       └── <name>_repository.dart       ← @LazySingleton(as: Abstract)
├── domain/
│   ├── domain.dart
│   ├── entities/
│   │   └── <entity>_entity.dart         ← plain class + Equatable
│   ├── repository/
│   │   └── <name>_repository.dart       ← abstract interface
│   └── usecases/
│       └── <verb>_<noun>_usecase.dart   ← @injectable
└── presentation/
    ├── presentation.dart
    ├── cubit/ или bloc/
    │   ├── <name>_cubit.dart            ← @injectable
    │   └── <name>_state.dart
    ├── pages/
    │   └── <name>_page.dart            ← @RoutePage()
    └── widgets/
        └── <widget_name>.dart
```

---

## 4. Слои

### 4.1 Domain

- **Entities** (`domain/entities/`) — plain Dart классы с `Equatable`. Без JSON, без Flutter.
- **Repository interface** (`domain/repository/`) — `abstract class <Name>Repository`. Методы возвращают `Future<Either<Failure, T>>`.
- **Use Cases** (`domain/usecases/`) — `@injectable`. Один use case = одно действие. Принимает репозиторий через конструктор. Возвращает `Future<Either<Failure, T>>`.

**Запрещено в domain:** `dio`, `flutter_secure_storage`, `shared_preferences`, `flutter/material`, DTO-модели.

### 4.2 Data

- **Models (DTO)** — `@freezed` + `@JsonSerializable`. Имеют `fromJson`, `toJson`, `fromEntity()` фабрику и `toEntity()` extension. Не выходят за пределы data-слоя.
- **Datasources** — `abstract interface + Impl`. Remote impl инжектирует `Dio` или клиент из `network`-пакета. Ловит ошибки и возвращает `Either<Failure, T>` или бросает `ServerException`.
- **Repository Impl** — `@LazySingleton(as: AbstractRepository)`. Делегирует datasource, конвертирует model → entity через `.toEntity()`. Использует `RepositoryErrorHandler` mixin для обёртки запросов.

### 4.3 Presentation

- **Cubit** — для простого состояния. `@injectable`. State — plain класс с `copyWith` + `Equatable`. Вызывает репозиторий или use case, обрабатывает через `result.fold(...)`.
- **BLoC** — для event-driven логики (корзина, заказы). События — `sealed class ... extends Equatable`. Состояния — `sealed class` с `final class` вариантами.
- **Pages** — помечаются `@RoutePage()`. Используют `BlocProvider`/`BlocBuilder`/`BlocListener`.
- **Widgets** — StatelessWidget или StatefulWidget. Получают данные через `context.read<>()` или пропсами.

---

## 5. Dependency Injection

**Фреймворк**: `get_it` + `injectable` (кодогенерация в `injectable_config.config.dart`).

### Аннотации

| Аннотация | Когда использовать |
|---|---|
| `@injectable` | Cubit, BLoC, UseCase — новый экземпляр каждый раз |
| `@lazySingleton` | Repository, DataSource, Service — один экземпляр |
| `@singleton` | Редко, для немедленной инициализации |
| `@LazySingleton(as: Abstract)` | Impl регистрируется как абстракция |
| `@preResolve` | Async инициализация (Hive, SharedPreferences) |
| `@module` | Внешние зависимости (Dio, SharedPreferences, SecureStorage) |

### Резолв зависимостей

```dart
// Глобальный экземпляр
final sl = GetIt.instance; // в lib/core/di/injectable_config.dart

// В виджетах/роутах
sl<CartBloc>()
sl<MenuCategoryCubit>()
```

### Инициализация

```dart
// main.dart
Future<void> main() async {
  await bootstrap();
  runApp(const App());
}

// bootstrap.dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    _initHive(),                                              // Phase 1 (параллельно)
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  Bloc.observer = AppBlocObserver(...);
  await di.init();                                           // Phase 2: DI (@preResolve)

  await SystemChrome.setPreferredOrientations([...]);        // Phase 3: UI
}
```

### Регистрация модуля

```dart
// app/lib/core/di/register_module.dart
@module
abstract class RegisterModule {
  @lazySingleton
  SecureStorage get secureStorage => SecureStorageImpl();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<LocalStorage> localStorage(SharedPreferences prefs) async { ... }

  @lazySingleton
  Dio get dio { /* с AuthInterceptor, LoggerInterceptor */ }
}
```

---

## 6. Обработка ошибок

### Иерархия Failure

```dart
// app/lib/core/error/failure.dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, [this.statusCode]);
  factory ServerFailure.fromDio(DioException e) { ... }
}

class NetworkFailure extends Failure { ... }
class CacheFailure extends Failure { ... }
class FormatFailure extends Failure { ... }
```

### RepositoryErrorHandler mixin

```dart
mixin RepositoryErrorHandler {
  Future<Either<Failure, T>> makeRequest<T>(Future<T> Function() request) async {
    try {
      return Right(await request());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDio(e));
    } on FormatException catch (e) {
      return Left(FormatFailure('Parse error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Unexpected: $e'));
    }
  }
}
```

### Паттерн использования Either

```dart
// В репозитории
Future<Either<Failure, List<CategoryEntity>>> getFoodsCategory() async {
  return makeRequest(() async {
    final response = await _dio.get(ApiConst.getCategories, ...);
    return (response.data['message'] as List)
        .map((e) => CategoryModel.fromJson(e).toEntity())
        .toList();
  });
}

// В cubit/bloc
result.fold(
  (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
  (data)    => emit(state.copyWith(isLoading: false, items: data)),
);
```

---

## 7. Навигация (auto_route)

**Файл**: `app/lib/core/router/routes.dart`

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true, guards: [InitialGuard()]),
    AutoRoute(page: MainHomeRoute.page, children: [
      AutoRoute(page: MenuRoute.page),
      AutoRoute(page: ProfileRoute.page, guards: [AuthGuard()]),
      // ...
    ]),
    AutoRoute(page: CartRoute.page),
    // ...
  ];
}
```

- Каждая страница помечается `@RoutePage()`.
- Guards реализуют `AutoRouteGuard.onNavigation(resolver, router)`.
- Навигация: `context.router.push(SomeRoute())`, `context.router.maybePop()`.
- Генерация: `fvm flutter pub run build_runner build --delete-conflicting-outputs`.

---

## 8. Шаблоны кода

### Entity (domain/entities)

```dart
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final int price;

  const ProductEntity({required this.id, required this.name, required this.price});

  @override
  List<Object?> get props => [id, name, price];
}
```

### Model (data/models) — @freezed

```dart
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    String? id,
    String? name,
    int? price,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  factory ProductModel.fromEntity(ProductEntity e) => ProductModel(
    id: e.id, name: e.name, price: e.price,
  );
}

extension ProductModelX on ProductModel {
  ProductEntity toEntity() => ProductEntity(
    id: id ?? '', name: name ?? '', price: price ?? 0,
  );
}
```

### Repository Interface (domain/repository)

```dart
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
}
```

### Repository Impl (data/repositories)

```dart
@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl with RepositoryErrorHandler implements ProductRepository {
  final ProductRemoteDataSource _remote;

  ProductRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() {
    return makeRequest(() async {
      final models = await _remote.getProducts();
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
```

### Use Case (domain/usecases)

```dart
@injectable
class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return _repository.getProducts();
  }
}
```

### Cubit (presentation/cubit)

```dart
@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _useCase;

  ProductCubit(this._useCase) : super(const ProductState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _useCase();
    if (isClosed) return;
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }
}

class ProductState extends Equatable {
  final List<ProductEntity> items;
  final bool isLoading;
  final String? error;

  const ProductState({this.items = const [], this.isLoading = false, this.error});

  ProductState copyWith({List<ProductEntity>? items, bool? isLoading, String? error}) {
    return ProductState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}
```

### BLoC с sealed states (presentation/bloc)

```dart
@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(CartRepository repository) : super(CartInitial()) {
    on<LoadCart>(_onLoad);
    on<AddItemToCart>(_onAdd);
  }
}

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override List<Object?> get props => [];
}
class LoadCart extends CartEvent {}
class AddItemToCart extends CartEvent {
  final CartItemEntity item;
  const AddItemToCart(this.item);
  @override List<Object?> get props => [item];
}

sealed class CartState extends Equatable {
  const CartState();
  @override List<Object?> get props => [];
}
final class CartInitial extends CartState {}
final class CartLoading extends CartState {}
final class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  const CartLoaded({required this.items});
  @override List<Object?> get props => [items];
}
final class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override List<Object?> get props => [message];
}
```

### Page (presentation/pages)

```dart
@RoutePage()
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCubit>()..load(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text(state.error!));
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (_, i) => ProductTile(item: state.items[i]),
          );
        },
      ),
    );
  }
}
```

---

## 9. Константы и ключи

**API эндпоинты**: `app/lib/core/constants/api_const/api_const.dart` — класс `ApiConst` со `static const String`.

**SharedPreferences ключи**: `app/lib/core/constants/app_const/app_const.dart` — класс `AppConst`.

Ключи хранилища:
- `AppConst.accessToken`, `AppConst.refreshToken` — токены
- `AppConst.userId`, `AppConst.userRole`, `AppConst.phone` — данные пользователя
- `AppConst.isDark` — тема
- `AppConst.savedAddress`, `AppConst.savedAddressLat`, `AppConst.savedAddressLon` — адрес
- `AppConst.firstLaunch` — первый запуск

**Никогда не используй строковые литералы** для ключей хранилища — только через `AppConst`.

---

## 10. Правила

### Обязательно

- `const` конструкторы везде, где возможно
- `final` поля
- `required` именованные параметры в конструкторах
- Barrel exports в каждом слое (`data.dart`, `domain.dart`, `presentation.dart`)
- `if (isClosed) return;` после `await` в cubit
- `result.fold(onLeft: ..., onRight: ...)` для обработки Either — **не** `result.getOrElse`
- Импорты только через barrel-файлы пакетов

### Запрещено

- Импорт `dio`, `shared_preferences`, `flutter_secure_storage` в domain-слое
- Импорт `lib/features/X/` из `lib/features/Y/` (фичи не зависят друг от друга)
- DTO (`*Model`) за пределами data-слоя
- BLoC/Cubit, обращающийся к datasource напрямую (только через repository)
- Строковые литералы эндпоинтов/ключей — только через `ApiConst`/`AppConst`
- `dartz` — используем только `fpdart`
- Предлагать `Riverpod`, `GetX`, `Provider` — проект на `flutter_bloc`
- `prefs.clear()` в logout — только точечное удаление auth-ключей

---

## 11. Добавление новой фичи

Порядок файлов:

1. `domain/entities/<entity>_entity.dart`
2. `domain/repository/<name>_repository.dart` (abstract)
3. `domain/usecases/<verb>_<noun>_usecase.dart` (@injectable)
4. `data/models/<entity>_model.dart` (@freezed — запустить build_runner)
5. `data/datasources/remote/<name>_remote_data_source.dart` (abstract + Impl @LazySingleton)
6. `data/repositories/<name>_repository.dart` (@LazySingleton(as: Abstract))
7. `presentation/cubit/<name>_cubit.dart` + `<name>_state.dart` (@injectable)
8. `presentation/pages/<name>_page.dart` (@RoutePage())
9. Добавить в `AppRouter.routes`
10. Запустить: `fvm flutter pub run build_runner build --delete-conflicting-outputs`

---

## 12. Чек-лист code review

- [ ] Domain не импортирует `dio`, `flutter_secure_storage`, `shared_preferences`, `flutter/material`
- [ ] Data не импортирует presentation-слой
- [ ] Фичи не импортируют друг друга
- [ ] Все модели `@freezed`, entity — plain class с Equatable
- [ ] Repository impl помечен `@LazySingleton(as: AbstractClass)`
- [ ] Cubit/BLoC помечен `@injectable`
- [ ] В cubit после `await` стоит `if (isClosed) return;`
- [ ] `result.fold(...)` для обработки Either в presentation
- [ ] DTO не выходит за пределы data-слоя
- [ ] Нет строковых литералов эндпоинтов/ключей — используются `ApiConst`/`AppConst`
- [ ] Barrel exports обновлены
- [ ] `fvm flutter analyze` — 0 ошибок
