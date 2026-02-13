import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/home/home_event.dart';
import 'package:global/bloc/home/home_state.dart';
import 'package:global/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeLoading()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final homeData = await homeRepository.getHomeData();
      emit(HomeLoaded(homeData: homeData));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
