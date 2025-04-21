import 'package:bloc/bloc.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit(this._repository) : super(AboutUsInitial());

  final AboutUsRepository _repository;

  void getAboutUs({required String type}) async {
    emit(AboutUsLoading());
    try {
      final aboutUs = await _repository.getAboutUs(type: type);
      emit(AboutUsLoaded(aboutUs));
    } catch (e) {
      emit(AboutUsError(e.toString()));
    }
  }
}
