import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/data/model/get_user_moderl.dart';

abstract class CurierRepository {
  Future<List<CurierOrderModel>> getCuriers();
  Future<void> getFinishOrder(int orderId);
  Future<List<CurierOrderModel>> getCurierHistory();
  Future<GetUserModel> getUser();
}

class CurierRepositoryImpl extends CurierRepository {
  final CurierDataSource dataSource;

  CurierRepositoryImpl(this.dataSource);

  @override
  Future<List<CurierOrderModel>> getCuriers() async {
    return await dataSource.getCuriers();
  }

  @override
  Future<void> getFinishOrder(int orderId) async {
    return await dataSource.getFinishOrder(orderId);
  }

  @override
  Future<List<CurierOrderModel>> getCurierHistory() async {
    return await dataSource.getCurierHistory();
  }

  @override
  Future<GetUserModel> getUser() async {
    return await dataSource.getUser();
  }
}
