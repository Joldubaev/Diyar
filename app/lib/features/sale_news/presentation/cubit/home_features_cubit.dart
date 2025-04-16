import 'package:bloc/bloc.dart';
import '../../data/model/news_model.dart';
import '../../data/model/sale_model.dart';
import '../../data/repositories/home_repository.dart';

part 'home_features_state.dart';

class HomeFeaturesCubit extends Cubit<HomeFeaturesState> {
  HomeFeaturesCubit(this.homeFeaturesRepo) : super(HomeFeaturesInitial());

  final HomeRepository homeFeaturesRepo;

  void getNews() async {
    emit(GetNewsLoading());
    try {
      final news = await homeFeaturesRepo.getNews();
      emit(GetNewsLoaded(news: news));
    } catch (e) {
      emit(GetNewsError(message: e.toString()));
    }
  }

  void getSales() async {
    emit(GetSalesLoading());
    try {
      final sales = await homeFeaturesRepo.getSales();
      emit(GetSalesLoaded(sales: sales));
    } catch (e) {
      emit(GetSalesError(message: e.toString()));
    }
  }
}
