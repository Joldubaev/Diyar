import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/data/data.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';

@LazySingleton(as: AboutUsRepository)
class AboutUsRepositoryImpl with RepositoryErrorHandler implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;

  AboutUsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, AboutUsEntity>> getAboutUs({required String type}) {
    return makeRequest(() async {
      final model = await _dataSource.getAboutUs(type: type);
      return model.toEntity();
    });
  }
}
