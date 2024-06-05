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

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void _observe(NetworkObserve event, Emitter<InternetState> emit) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      add(NetworkNotify(isConnected: result != ConnectivityResult.none));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  void _notifyStatus(NetworkNotify event, Emitter<InternetState> emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }
}
