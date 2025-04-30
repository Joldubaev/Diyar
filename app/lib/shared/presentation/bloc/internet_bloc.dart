import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc._() : super(InternetInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  static final InternetBloc _instance = InternetBloc._();

  factory InternetBloc() => _instance;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void _observe(NetworkObserve event, Emitter<InternetState> emit) {
    // Отменяем предыдущее подписывание, если оно существует
    _connectivitySubscription?.cancel();

    // Подписываемся на изменения состояния сети
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Проверяем, если хоть одно подключение активно
      final isConnected = results.any((result) => result != ConnectivityResult.none);

      // Уведомляем Bloc об изменении состояния подключения
      add(NetworkNotify(isConnected: isConnected));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  void _notifyStatus(NetworkNotify event, Emitter<InternetState> emit) {
    // Выдаём соответствующее состояние
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }
}
