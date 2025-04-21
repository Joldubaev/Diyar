import 'package:diyar/features/about_us/data/data.dart';
import 'package:diyar/features/about_us/domain/domain.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;

  AboutUsRepositoryImpl(this._dataSource);

  @override
  Future<AboutUsEntities> getAboutUs({required String type}) {
    return _dataSource.getAboutUs(type: type).then((model) => model.toEntity());
  }
}
