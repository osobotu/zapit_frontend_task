part of 'coins_list_cubit.dart';

abstract class CoinsListState extends Equatable {}

class CoinsListInitial extends CoinsListState {
  @override
  List<Object?> get props => [];
}

class CoinsListLoading extends CoinsListState {
  @override
  List<Object?> get props => [];
}

class CoinsListLoaded extends CoinsListState {
  CoinsListLoaded({required this.coins});
  final List<Coin> coins;
  @override
  List<Object?> get props => [coins];
}

class CoinsListError extends CoinsListState {
  @override
  List<Object?> get props => [];
}
