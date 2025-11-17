import 'package:bloc/bloc.dart';
import 'package:diyar/features/home_content/domain/usecases/get_news.dart';
import 'package:diyar/features/home_content/domain/usecases/get_sales.dart';
import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:injectable/injectable.dart';

part 'home_content_state.dart';

@injectable
class HomeContentCubit extends Cubit<HomeContentState> {
  final GetNewsUseCase _getNewsUseCase;
  final GetSalesUseCase _getSalesUseCase;

  HomeContentCubit({
    required GetNewsUseCase getNewsUseCase,
    required GetSalesUseCase getSalesUseCase,
  })  : _getNewsUseCase = getNewsUseCase,
        _getSalesUseCase = getSalesUseCase,
        super(HomeContentInitial());

  Future<void> getNews() async {
    emit(GetNewsLoading());
    final failureOrNews = await _getNewsUseCase();
    failureOrNews.fold(
      (failure) => emit(HomeContentError(message: failure.toString())),
      (news) => emit(GetNewsLoaded(news: news)),
    );
  }

  Future<void> getSales() async {
    emit(GetSalesLoading());
    final failureOrSales = await _getSalesUseCase();
    failureOrSales.fold(
      (failure) => emit(HomeContentError(message: failure.toString())),
      (sales) => emit(GetSalesLoaded(sales: sales)),
    );
  }
}
