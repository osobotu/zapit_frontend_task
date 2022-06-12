part of 'price_list_cubit.dart';

abstract class PriceListState {}

class PriceListInitial extends PriceListState {}

class PriceListLoading extends PriceListState {}

class PriceListLoaded extends PriceListState {
  PriceListLoaded({required this.prices});
  final List<double> prices;
}

class PriceListError extends PriceListState {}
