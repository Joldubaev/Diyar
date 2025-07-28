# 🧱 Feature Brick - Mason Template

Этот Mason brick создает новую фичу с полной архитектурой Clean Architecture для Flutter приложения Diyar.

## 📁 Структура создаваемой фичи

```
{{name.snakeCase()}}/
├── {{name.snakeCase()}}.dart                    # Основной экспорт
├── {{name.snakeCase()}}_injection.dart          # Dependency injection
├── data/
│   ├── data.dart                               # Экспорты data слоя
│   ├── datasource/                             # Data sources
│   ├── models/                                 # Data models
│   └── repository/                             # Repository implementations
├── domain/
│   ├── domain.dart                             # Экспорты domain слоя
│   ├── entities/                               # Domain entities
│   └── repositories/                           # Repository interfaces
└── presentation/
    ├── presentation.dart                       # Экспорты presentation слоя
    ├── cubit/                                 # Cubit/Bloc
    ├── pages/                                 # Страницы
    └── widgets/                               # Виджеты
```

## 🚀 Как использовать

### 1. Установка Mason (если не установлен)

```bash
# Установка Mason CLI
dart pub global activate mason_cli

# Или через Homebrew (macOS)
brew install mason
```

### 2. Добавление brick в проект

```bash
# Добавить brick локально
mason add feature --source path ./bricks/feature

# Или добавить из Git репозитория
mason add feature --source git https://github.com/your-repo/bricks.git
```

### 3. Создание новой фичи

```bash
# Создать фичу с именем "user_profile"
mason make feature --name "user_profile"

# Создать фичу с именем "order_history" 
mason make feature --name "order_history"

# Создать фичу с именем "payment_methods"
mason make feature --name "payment_methods"
```

### 4. Интеграция в проект

После создания фичи нужно:

1. **Добавить экспорт в `lib/features/features.dart`:**
```dart
export '{{name.snakeCase()}}/{{name.snakeCase()}}.dart';
```

2. **Добавить инъекцию в `lib/injection_container.dart`:**
```dart
import 'features/{{name.snakeCase()}}/{{name.snakeCase()}}_injection.dart';

// В функции init()
await {{name.camelCase()}}Injection();
```

## 📝 Примеры использования

### Создание фичи "User Profile"

```bash
mason make feature --name "user_profile"
```

Создаст структуру:
```
user_profile/
├── user_profile.dart
├── user_profile_injection.dart
├── data/
│   ├── data.dart
│   ├── datasource/
│   ├── models/
│   └── repository/
├── domain/
│   ├── domain.dart
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── presentation.dart
    ├── cubit/
    ├── pages/
    └── widgets/
```

### Создание фичи "Order History"

```bash
mason make feature --name "order_history"
```

Создаст структуру:
```
order_history/
├── order_history.dart
├── order_history_injection.dart
├── data/
│   ├── data.dart
│   ├── datasource/
│   ├── models/
│   └── repository/
├── domain/
│   ├── domain.dart
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── presentation.dart
    ├── cubit/
    ├── pages/
    └── widgets/
```

## 🔧 Настройка brick

### Изменение переменных

Отредактируй `brick.yaml`:

```yaml
name: feature
description: A new brick created with the Mason CLI.
version: 0.1.0+1

environment:
  mason: ">=0.1.0-dev.51 <0.2.0"

vars:
  name:
    type: string
    default: One
    prompt: Feature name? ('One' by default)
    # Можно добавить валидацию:
    # validator: ^[a-zA-Z_][a-zA-Z0-9_]*$
```

### Добавление новых переменных

```yaml
vars:
  name:
    type: string
    default: One
    prompt: Feature name?
  
  # Новая переменная
  description:
    type: string
    default: "Feature description"
    prompt: Feature description?
```

## 🎯 Лучшие практики

### 1. Именование фич
- Используй **snake_case** для имен: `user_profile`, `order_history`
- Избегай пробелов и специальных символов

### 2. Структура файлов
- Следуй Clean Architecture
- Разделяй data, domain, presentation слои
- Используй dependency injection

### 3. Интеграция
- Всегда добавляй экспорты в `features.dart`
- Регистрируй инъекции в `injection_container.dart`
- Следуй существующим паттернам проекта

## 🐛 Устранение проблем

### Ошибка "brick not found"
```bash
# Проверь список доступных bricks
mason list

# Добавь brick заново
mason add feature --source path ./bricks/feature
```

### Ошибка при создании
```bash
# Очисти кэш Mason
mason cache clean

# Попробуй снова
mason make feature --name "test_feature"
```

## 📚 Полезные команды

```bash
# Список всех bricks
mason list

# Информация о brick
mason info feature

# Очистка кэша
mason cache clean

# Удаление brick
mason remove feature
```

## 🔄 Обновление brick

```bash
# Обновить brick из Git
mason add feature --source git https://github.com/your-repo/bricks.git --overwrite

# Или обновить локальный brick
mason add feature --source path ./bricks/feature --overwrite
```

---

**Создано для проекта Diyar** 🚀 