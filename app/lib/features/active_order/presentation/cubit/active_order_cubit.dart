import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/active_order/domain/domain.dart';

part 'active_order_state.dart';

class ActiveOrderCubit extends Cubit<ActiveOrderState> {
  final ActiveOrderRepository repository;
  ActiveOrderCubit(this.repository) : super(ActiveOrderInitial());
}
