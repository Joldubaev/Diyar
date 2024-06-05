part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}

class NetworkObserve extends InternetEvent {}

class NetworkNotify extends InternetEvent {
  final bool isConnected;

  const NetworkNotify({this.isConnected = false});
}