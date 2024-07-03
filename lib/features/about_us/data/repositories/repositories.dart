import 'package:diyar/features/features.dart';

abstract class AboutUsRepository {
  Future<AboutUsModel> getAboutUs({required String type});
}

class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource _dataSource;

  AboutUsRepositoryImpl(this._dataSource);

  @override
  Future<AboutUsModel> getAboutUs({required String type}) {
    return _dataSource.getAboutUs(type: type);
  }
}
