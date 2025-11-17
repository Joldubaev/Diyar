# Руководство по использованию Injectable в Clean Architecture

## 📋 Содержание
1. [Обзор аннотаций](#обзор-аннотаций)
2. [Использование по слоям архитектуры](#использование-по-слоям-архитектуры)
3. [Примеры для каждого типа класса](#примеры-для-каждого-типа-класса)
4. [Антипаттерны](#антипаттерны)
5. [Рекомендации по модулям](#рекомендации-по-модулям)

---

## 🎯 Обзор аннотаций

### 1. `@injectable` (Factory)
**Смысл:** Создаёт новый экземпляр каждый раз при запросе зависимости.

**Поведение:**
- Каждый вызов `sl<MyClass>()` создаёт новый объект
- Используется для краткоживущих объектов
- Не хранит состояние между вызовами

**Когда использовать:**
- ✅ **Cubit/Bloc** — каждый экран должен иметь свой экземпляр
- ✅ **UseCase** — краткоживущие операции
- ✅ **Временные сервисы** — не требуют сохранения состояния

**Пример:**
```dart
@injectable
class AboutUsCubit extends Cubit<AboutUsState> {
  final AboutUsRepository _repository;
  AboutUsCubit(this._repository) : super(AboutUsInitial());
}
```

---

### 2. `@lazySingleton`
**Смысл:** Создаёт один экземпляр при первом обращении и переиспользует его.

**Поведение:**
- Создаётся только при первом вызове `sl<MyClass>()`
- Один экземпляр на всё время жизни приложения
- Ленивая инициализация (не создаётся при старте приложения)

**Когда использовать:**
- ✅ **Сервисы** — которые нужны везде, но не требуют немедленной инициализации
- ✅ **Кеш-менеджеры** — один экземпляр для всего приложения
- ✅ **Утилиты** — которые не зависят от других синглтонов

**Пример:**
```dart
@lazySingleton
class ImageCacheService {
  // Один экземпляр для всего приложения
}
```

---

### 3. `@LazySingleton(as: Interface)`
**Смысл:** Регистрирует реализацию интерфейса как ленивый синглтон.

**Поведение:**
- Регистрируется по типу интерфейса, а не реализации
- При запросе `sl<Interface>()` возвращается реализация
- Один экземпляр на всё время жизни

**Когда использовать:**
- ✅ **Repository Implementation** — реализация domain-интерфейса
- ✅ **DataSource Implementation** — реализация data-интерфейса
- ✅ **Любая реализация абстракции** — когда нужен один экземпляр

**Пример:**
```dart
// Domain (интерфейс)
abstract class AboutUsRepository {
  Future<AboutUsEntities> getAboutUs({required String type});
}

// Data (реализация)
@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;
  AboutUsRepositoryImpl(this._dataSource);
  
  @override
  Future<AboutUsEntities> getAboutUs({required String type}) {
    return _dataSource.getAboutUs(type: type).then((model) => model.toEntity());
  }
}
```

---

### 4. `@singleton`
**Смысл:** Создаёт экземпляр сразу при инициализации DI-контейнера.

**Поведение:**
- Создаётся при вызове `configureDependencies()`
- Всегда один экземпляр
- Немедленная инициализация (не ленивая)

**Когда использовать:**
- ✅ **Критичные сервисы** — должны быть готовы сразу
- ✅ **Конфигурация** — которая нужна при старте
- ⚠️ **Редко** — обычно предпочтительнее `@lazySingleton`

**Пример:**
```dart
@singleton
class AppConfigService {
  // Создаётся сразу при старте приложения
}
```

---

## 🏗️ Использование по слоям архитектуры

### 📁 **data/** слой

#### **remote_datasource/**
```dart
// ✅ ПРАВИЛЬНО: Реализация интерфейса как LazySingleton
abstract class AboutUsRemoteDataSource {
  Future<AboutUsModel> getAboutUs({required String type});
}

@LazySingleton(as: AboutUsRemoteDataSource)
class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  final Dio _dio;
  final LocalStorage _localStorage;
  
  AboutUsRemoteDataSourceImpl(this._dio, this._localStorage);
  
  @override
  Future<AboutUsModel> getAboutUs({required String type}) async {
    // Реализация
  }
}
```

**Почему `@LazySingleton(as:)`:**
- DataSource — синглтон (один экземпляр для всего приложения)
- Регистрация по интерфейсу позволяет легко менять реализацию
- Ленивая инициализация — создаётся только при первом использовании

#### **repository/** (data слой)
```dart
// ✅ ПРАВИЛЬНО: Реализация domain-репозитория
@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;
  
  AboutUsRepositoryImpl(this._dataSource);
  
  @override
  Future<AboutUsEntities> getAboutUs({required String type}) {
    return _dataSource.getAboutUs(type: type).then((model) => model.toEntity());
  }
}
```

**Почему `@LazySingleton(as:)`:**
- Repository — синглтон (один экземпляр)
- Регистрация по domain-интерфейсу соблюдает инверсию зависимостей
- Ленивая инициализация

---

### 📁 **domain/** слой

#### **repositories/** (интерфейсы)
```dart
// ✅ ПРАВИЛЬНО: Интерфейс БЕЗ аннотаций
abstract class AboutUsRepository {
  Future<AboutUsEntities> getAboutUs({required String type});
}
```

**Почему без аннотаций:**
- Интерфейсы не регистрируются в DI
- Регистрируется только реализация с `@LazySingleton(as: Interface)`

#### **usecases/**
```dart
// ✅ ПРАВИЛЬНО: UseCase как @injectable (factory)
@injectable
class GetAboutUsUseCase {
  final AboutUsRepository _repository;
  
  GetAboutUsUseCase(this._repository);
  
  Future<Either<Failure, AboutUsEntities>> call(String type) async {
    return await _repository.getAboutUs(type: type);
  }
}
```

**Почему `@injectable`:**
- UseCase — краткоживущий объект
- Каждый вызов может создать новый экземпляр
- Не хранит состояние

**⚠️ ВАЖНО:** Если UseCase используется только в одном месте и не имеет состояния, можно использовать `@lazySingleton`, но `@injectable` предпочтительнее для чистоты архитектуры.

---

### 📁 **presentation/** слой

#### **cubit/**
```dart
// ✅ ПРАВИЛЬНО: Cubit как @injectable (factory)
@injectable
class AboutUsCubit extends Cubit<AboutUsState> {
  final AboutUsRepository _repository;
  
  AboutUsCubit(this._repository) : super(AboutUsInitial());
  
  void getAboutUs({required String type}) async {
    emit(AboutUsLoading());
    try {
      final aboutUs = await _repository.getAboutUs(type: type);
      emit(AboutUsLoaded(aboutUs));
    } catch (e) {
      emit(AboutUsError(e.toString()));
    }
  }
}
```

**Почему `@injectable`:**
- Каждый экран должен иметь свой экземпляр Cubit
- Cubit хранит состояние экрана
- При навигации создаётся новый экземпляр

**❌ НЕПРАВИЛЬНО:**
```dart
@lazySingleton  // ❌ ОШИБКА: состояние будет общим для всех экранов
class AboutUsCubit extends Cubit<AboutUsState> {
  // ...
}
```

---

## 🔧 Сервисы и инфраструктура

### **Dio / ApiClient**
```dart
// ✅ ПРАВИЛЬНО: В модуле RegisterModule
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    DioNetwork.initDio();
    return DioNetwork.appAPI;
  }
}
```

**Почему `@lazySingleton` в модуле:**
- Один экземпляр Dio для всего приложения
- Ленивая инициализация
- Модуль позволяет регистрировать внешние зависимости

### **LocalStorage / SharedPreferences**
```dart
// ✅ ПРАВИЛЬНО: В модуле RegisterModule
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  
  @preResolve
  Future<LocalStorage> get localStorage async {
    final prefs = await SharedPreferences.getInstance();
    return await LocalStorage.getInstance(prefs);
  }
}
```

**Почему `@preResolve`:**
- SharedPreferences требует асинхронной инициализации
- `@preResolve` гарантирует, что зависимость будет готова до использования
- Один экземпляр на всё приложение

### **Кеш-менеджеры**
```dart
// ✅ ПРАВИЛЬНО: Ленивый синглтон
@lazySingleton
class ImageCacheManager {
  // Один экземпляр для всего приложения
}
```

---

## ❌ Антипаттерны

### 1. **Cubit как синглтон**
```dart
// ❌ НЕПРАВИЛЬНО
@lazySingleton
class AboutUsCubit extends Cubit<AboutUsState> {
  // Состояние будет общим для всех экранов!
}

// ✅ ПРАВИЛЬНО
@injectable
class AboutUsCubit extends Cubit<AboutUsState> {
  // Каждый экран получает свой экземпляр
}
```

### 2. **UseCase как синглтон (если не требуется)**
```dart
// ❌ НЕПРАВИЛЬНО (если UseCase не хранит состояние)
@lazySingleton
class GetAboutUsUseCase {
  // Избыточно, если UseCase не хранит состояние
}

// ✅ ПРАВИЛЬНО
@injectable
class GetAboutUsUseCase {
  // Краткоживущий объект
}
```

**Исключение:** Если UseCase кеширует результаты или хранит состояние:
```dart
// ✅ ПРАВИЛЬНО (если UseCase кеширует)
@lazySingleton
class CachedGetAboutUsUseCase {
  final Map<String, AboutUsEntities> _cache = {};
  // ...
}
```

### 3. **Регистрация реализации без интерфейса**
```dart
// ❌ НЕПРАВИЛЬНО
@lazySingleton
class AboutUsRepositoryImpl implements AboutUsRepository {
  // Регистрация по конкретному типу нарушает инверсию зависимостей
}

// ✅ ПРАВИЛЬНО
@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  // Регистрация по интерфейсу
}
```

### 4. **DataSource без интерфейса**
```dart
// ❌ НЕПРАВИЛЬНО (если есть интерфейс)
@lazySingleton
class AboutUsRemoteDataSourceImpl {
  // Нарушает Clean Architecture
}

// ✅ ПРАВИЛЬНО
abstract class AboutUsRemoteDataSource {
  Future<AboutUsModel> getAboutUs({required String type});
}

@LazySingleton(as: AboutUsRemoteDataSource)
class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  // Регистрация по интерфейсу
}
```

### 5. **Использование @singleton вместо @lazySingleton**
```dart
// ❌ НЕПРАВИЛЬНО (если не требуется немедленная инициализация)
@singleton
class AboutUsRepositoryImpl implements AboutUsRepository {
  // Создаётся сразу при старте, даже если не используется
}

// ✅ ПРАВИЛЬНО
@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  // Создаётся только при первом использовании
}
```

---

## 📦 Рекомендации по модулям

### **Структура модуля (feature)**

Каждый модуль должен следовать этой структуре:

```
features/
  about_us/
    data/
      models/
      remote_datasource/
        about_us_remote_datasource.dart  # @LazySingleton(as: Interface)
      repository/
        repository.dart                   # @LazySingleton(as: DomainInterface)
    domain/
      entities/
      repositories/
        about_us_repositories.dart        # Интерфейс БЕЗ аннотаций
      usecases/
        get_about_us_usecase.dart         # @injectable
    presentation/
      cubit/
        about_us_cubit.dart               # @injectable
      pages/
      widgets/
```

### **Порядок регистрации в injectable_config**

Injectable автоматически находит все аннотированные классы, но порядок важен для зависимостей:

1. **Сначала модули** (`@module`) — регистрируют внешние зависимости
2. **Затем DataSource** — базовые источники данных
3. **Затем Repository** — зависят от DataSource
4. **Затем UseCase** — зависят от Repository
5. **Затем Cubit** — зависят от Repository или UseCase

**Пример правильного порядка:**
```dart
// 1. Модуль (внешние зависимости)
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioNetwork.appAPI;
}

// 2. DataSource
@LazySingleton(as: AboutUsRemoteDataSource)
class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  final Dio _dio;
  AboutUsRemoteDataSourceImpl(this._dio);
}

// 3. Repository
@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;
  AboutUsRepositoryImpl(this._dataSource);
}

// 4. UseCase (опционально)
@injectable
class GetAboutUsUseCase {
  final AboutUsRepository _repository;
  GetAboutUsUseCase(this._repository);
}

// 5. Cubit
@injectable
class AboutUsCubit extends Cubit<AboutUsState> {
  final AboutUsRepository _repository;
  AboutUsCubit(this._repository) : super(AboutUsInitial());
}
```

---

## 📝 Чек-лист для нового модуля

При создании нового модуля проверь:

- [ ] **DataSource** использует `@LazySingleton(as: Interface)`
- [ ] **Repository** использует `@LazySingleton(as: DomainInterface)`
- [ ] **UseCase** использует `@injectable` (или `@lazySingleton` если кеширует)
- [ ] **Cubit** использует `@injectable`
- [ ] **Интерфейсы** (domain) НЕ имеют аннотаций
- [ ] **Внешние зависимости** (Dio, LocalStorage) в `@module`
- [ ] Все зависимости указаны в конструкторе
- [ ] Запущен `build_runner` для генерации кода

---

## 🎯 Итоговая таблица

| Тип класса | Аннотация | Пример |
|------------|-----------|--------|
| **Cubit/Bloc** | `@injectable` | `AboutUsCubit` |
| **UseCase** (без кеша) | `@injectable` | `GetAboutUsUseCase` |
| **UseCase** (с кешем) | `@lazySingleton` | `CachedGetAboutUsUseCase` |
| **Repository Impl** | `@LazySingleton(as: Interface)` | `AboutUsRepositoryImpl` |
| **DataSource Impl** | `@LazySingleton(as: Interface)` | `AboutUsRemoteDataSourceImpl` |
| **Сервисы** | `@lazySingleton` | `ImageCacheService` |
| **Dio/ApiClient** | `@lazySingleton` в `@module` | `RegisterModule` |
| **LocalStorage** | `@preResolve` в `@module` | `RegisterModule` |
| **Интерфейсы** | Без аннотаций | `AboutUsRepository` |

---

## 🔍 Дополнительные советы

1. **Именование:** Всегда используй `Impl` суффикс для реализаций
2. **Зависимости:** Указывай все зависимости в конструкторе (injectable автоматически их инжектит)
3. **Тестирование:** Используй интерфейсы для легкого мокирования в тестах
4. **Генерация:** После добавления аннотаций всегда запускай `flutter pub run build_runner build --delete-conflicting-outputs`

---

**Создано для проекта Diyar** 🚀

