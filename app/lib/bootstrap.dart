import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injectable_config.dart' as di;
import 'core/utils/app_bloc_observer.dart';
import 'features/cart/data/models/cart_item_model_hive_adapter.dart';
import 'features/menu/data/models/food_model_hive_adapter.dart';
import 'firebase_options.dart';

/// Initializes all app services. Uses [Future.wait] to run independent
/// initializations in parallel for faster startup.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phase 1: Independent async inits (parallel)
  await Future.wait([
    _initHive(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // Phase 2: DI depends on Hive and Firebase being ready
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver(
    onLog: (message, {required String name}) => log(message, name: name),
  );

  await di.init();

  // Phase 3: UI config (sync, fast)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(FoodModelAdapter());
}
