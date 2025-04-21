import 'package:diyar/features/about_us/domain/domain.dart';

abstract class AboutUsRepository {
  Future<AboutUsEntities> getAboutUs({required String type});
}
