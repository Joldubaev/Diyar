import 'package:dio/dio.dart';
import 'package:diyar/features/bonuses/bonuses.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BonusesRepository)
class BonusesRepositoryImpl implements BonusesRepository{
  final Dio dio;

  BonusesRepositoryImpl(this.dio);
}