import 'package:dio/dio.dart';
import 'package:diyar/features/active_order/domain/domain.dart';



class ActiveOrderRepositoryImpl implements ActiveOrderRepository{
  final Dio dio;

  ActiveOrderRepositoryImpl(this.dio);
}