import 'package:diyar/features/bonuses/bonuses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bonuses_state.dart';

class BonusesCubit extends Cubit<BonusesState> {
  final BonusesRepository repository;
  BonusesCubit(this.repository) : super(BonusesInitial());
}
