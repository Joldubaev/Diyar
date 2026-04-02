import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AppColors', () {
    test('primary is correct hex value', () {
      // ignore: deprecated_member_use
      expect(AppColors.primary.toARGB32(), 0xFFD67C1C);
    });

    test('primary swatch has all shades', () {
      expect(AppColors.primary[50], isNotNull);
      expect(AppColors.primary[100], isNotNull);
      expect(AppColors.primary[500], isNotNull);
      expect(AppColors.primary[900], isNotNull);
    });

    test('semantic colors are defined', () {
      expect(AppColors.success, AppColors.green);
      expect(AppColors.error, AppColors.red);
      expect(AppColors.warning, AppColors.yellow);
      expect(AppColors.info, AppColors.blue);
    });
  });

  group('lightTheme', () {
    test('uses Inter font', () {
      expect(lightTheme.textTheme.bodyMedium?.fontFamily, 'Inter');
    });

    test('scaffold background is light', () {
      expect(lightTheme.scaffoldBackgroundColor, AppColors.backgroundLight);
    });

    test('primary color is AppColors.primary', () {
      expect(lightTheme.primaryColor, AppColors.primary);
    });

    test('card theme has 12px radius', () {
      final shape = lightTheme.cardTheme.shape as RoundedRectangleBorder;
      final radius = (shape.borderRadius as BorderRadius).topLeft;
      expect(radius, const Radius.circular(12));
    });
  });

  group('darkTheme', () {
    test('scaffold background is dark', () {
      expect(
        lightTheme.scaffoldBackgroundColor != darkTheme.scaffoldBackgroundColor,
        isTrue,
      );
    });

    test('brightness is dark', () {
      expect(darkTheme.colorScheme.brightness, Brightness.dark);
    });
  });

  group('ThemeContextExtension', () {
    testWidgets('provides theme accessors', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: lightTheme,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedContext.theme, isA<ThemeData>());
      expect(capturedContext.textTheme, isA<TextTheme>());
      expect(capturedContext.colorScheme, isA<ColorScheme>());
      expect(capturedContext.primaryColor, AppColors.primary);
      expect(capturedContext.scaffoldBg, AppColors.backgroundLight);
      expect(capturedContext.bgColor, AppColors.backgroundLight);
    });
  });
}
