import 'package:diyar/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:diyar/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:diyar/features/cart/domain/repository/cart_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CartModule {
  @preResolve
  Future<CartRepository> cartRepository(CartLocalDataSource dataSource) async {
    await dataSource.init();
    final repository = CartRepositoryImpl(dataSource);
    await repository.init();
    return repository;
  }
}

