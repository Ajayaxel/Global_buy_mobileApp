import 'package:equatable/equatable.dart';
import 'package:global/models/buyer_home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final BuyerHomeResponse homeData;

  const HomeLoaded({required this.homeData});

  @override
  List<Object> get props => [homeData];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
