part of 'about_us_cubit.dart';

abstract class AboutUsState extends Equatable {
  const AboutUsState();

  @override
  List<Object> get props => [];
}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsLoaded extends AboutUsState {
  final AboutUsEntities aboutUsModel;

  const AboutUsLoaded(this.aboutUsModel);

  @override
  List<Object> get props => [aboutUsModel];
}

class AboutUsError extends AboutUsState {
  final String message;

  const AboutUsError(this.message);

  @override
  List<Object> get props => [message];
}
