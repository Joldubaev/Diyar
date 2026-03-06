part of 'address_selection_cubit.dart';

sealed class AddressSelectionState extends Equatable {
  const AddressSelectionState();

  @override
  List<Object?> get props => [];
}

final class AddressSelectionInitial extends AddressSelectionState {
  const AddressSelectionInitial();
}

final class AddressSelectionData extends AddressSelectionState {
  final double latitude;
  final double longitude;
  final String? address;
  final bool isLoading;

  const AddressSelectionData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [latitude, longitude, address, isLoading];
}

final class AddressSelectionMoveTo extends AddressSelectionState {
  final double latitude;
  final double longitude;

  const AddressSelectionMoveTo(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

final class AddressSelectionLoading extends AddressSelectionState {
  const AddressSelectionLoading();
}

final class AddressSelectionConfirmed extends AddressSelectionState {
  const AddressSelectionConfirmed();
}

final class AddressSelectionSearchError extends AddressSelectionState {
  final String message;

  const AddressSelectionSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
