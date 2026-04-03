import 'package:diyar/core/bloc/base_cubit.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'about_us_state.dart';

@injectable
class AboutUsCubit extends BaseCubit<AboutUsState> {
  AboutUsCubit(this._repository) : super(const AboutUsInitial());

  final AboutUsRepository _repository;

  Future<void> getAboutUs({required String type}) {
    return handleEither(
      call: () => _repository.getAboutUs(type: type),
      onLoading: () => const AboutUsLoading(),
      onSuccess: (data) => AboutUsLoaded(data),
      onFailure: (f) => AboutUsError(f.message),
    );
  }
}
