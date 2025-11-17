import 'package:diyar/features/bonuses/bonuses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'bonuses_state.dart';

@injectable
class BonusesCubit extends Cubit<BonusesState> {
  final BonusesRepository repository;
  BonusesCubit(this.repository) : super(BonusesInitial());
}
