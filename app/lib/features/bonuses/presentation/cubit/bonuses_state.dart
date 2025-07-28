part of 'bonuses_cubit.dart';

sealed class BonusesState extends Equatable {
  const BonusesState();

  @override
  List<Object> get props => [];
}

final class BonusesInitial extends BonusesState {}
