import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:fpdart/fpdart.dart' show Either;

abstract class AboutUsRepository {
  Future<Either<Failure, AboutUsEntity>> getAboutUs({required String type});
}
