part of 'coins_list_cubit.dart';

abstract class CoinsListState {}

class CoinsListInitial extends CoinsListState {}

class CoinsListLoading extends CoinsListState {}

class CoinsListLoaded extends CoinsListState {
  CoinsListLoaded({required this.coins});
  final List<Coin> coins;
}

class CoinsListError extends CoinsListState {}
