# Diyar

<p align="center">
  <a href="https://apps.apple.com/app/idXXXXXXXXX">
    <img src="doc/images/app_store.png" alt="Get it on App Store" width="30%">
  </a>
  &emsp; &emsp;&emsp;&emsp;&emsp;
  <a href="https://play.google.com/store/apps/details?id=com.diyar.app">
    <img src="doc/images/google_play.png" alt="Get it on Play Store" width="30%">
  </a>
</p>

Diyar — современное приложение для заказа и доставки еды, созданное на Flutter. Заказывайте любимые блюда из ресторанов, оплачивайте онлайн, отслеживайте статус заказа в реальном времени и пользуйтесь безопасной авторизацией с помощью биометрии и пин-кода.

<!-- <p align="center">
  <img src="doc/screens/01-home.png" width="22%" />
  <img src="doc/screens/02-menu.png" width="22%" />
  <img src="doc/screens/03-cart.png" width="22%" />
  <img src="doc/screens/04-payment.png" width="22%" />
</p> -->

## Основные возможности

- Просмотр ресторанов и блюд с удобной навигацией
- Оформление заказа и онлайн-оплата (MegaPay, MBank, QR и др.)
- Отслеживание статуса заказа в реальном времени
- История заказов и управление профилем
- Авторизация по биометрии и пин-коду
- Современный UI, плавные анимации, быстрый отклик

## Требования

- Dart sdk: ">=3.7.0-0 <4.0.0"
- Flutter: "3.29.0"
- Android: minSdkVersion 23
- iOS: Xcode >= 15.4.0

## Установка и запуск

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/your-username/diyar.git
   cd diyar
   ```
2. Установите зависимости:
   ```bash
   flutter pub get
   ```
3. Запустите приложение:
   ```bash
   flutter run
   ```

## Скрипты и тесты

- Форматирование кода:
  ```bash
  dart format .
  ```
- Запуск всех тестов:
  ```bash
  flutter test
  ```

## Работа с Melos (монорепозиторий)

[Melos](https://melos.invertase.dev/) — инструмент для управления большим Flutter/Dart проектом с несколькими пакетами (монорепо).

### Установка Melos

```bash
dart pub global activate melos
```

### Bootstrap (инициализация зависимостей)

```bash
melos bootstrap
```

### Запуск приложения

```bash
melos run-app
```

### Запуск тестов

```bash
melos test
```

### Форматирование кода

```bash
melos format-all
```

### Генерация .g файлов (build_runner)

```bash
melos run-build-runner-all
```

---

Diyar — ваш быстрый и удобный способ заказать еду онлайн!
flutter build appbundle --analyze-size --target-platform android-arm64

flutter build apk --analyze-size --target-platform android-arm64

flutter build apk --split-per-abi --release