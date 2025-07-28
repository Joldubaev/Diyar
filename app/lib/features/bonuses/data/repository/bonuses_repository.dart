import 'package:dio/dio.dart';
import 'package:diyar/features/bonuses/bonuses.dart';



class BonusesRepositoryImpl implements BonusesRepository{
  final Dio dio;

  BonusesRepositoryImpl(this.dio);
}