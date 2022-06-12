part of 'price_list_cubit.dart';

abstract class PriceListState extends Equatable {}

class PriceListInitial extends PriceListState {
  @override
  List<Object?> get props => [];
}

class PriceListLoading extends PriceListState {
  @override
  List<Object?> get props => [];
}

class PriceListLoaded extends PriceListState {
  PriceListLoaded({required this.prices});
  final List<double> prices;
  @override
  List<Object?> get props => [prices];
}

class PriceListError extends PriceListState {
  @override
  List<Object?> get props => [];
}
