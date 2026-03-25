# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Yandex MapKit
-keep class com.yandex.** { *; }
-keep class ru.yandex.** { *; }
-dontwarn com.yandex.**
-dontwarn ru.yandex.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
