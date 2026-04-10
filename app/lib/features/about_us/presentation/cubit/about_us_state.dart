part of 'about_us_cubit.dart';

sealed class AboutUsState extends Equatable {
  const AboutUsState();

  @override
  List<Object?> get props => [];
}

final class AboutUsInitial extends AboutUsState {
  const AboutUsInitial();
}

final class AboutUsLoading extends AboutUsState {
  const AboutUsLoading();
}

final class AboutUsLoaded extends AboutUsState {
  final AboutUsEntity aboutUsModel;

  const AboutUsLoaded(this.aboutUsModel);

  @override
  List<Object?> get props => [aboutUsModel];
}

final class AboutUsError extends AboutUsState {
  final String message;

  const AboutUsError(this.message);

  @override
  List<Object?> get props => [message];
}
