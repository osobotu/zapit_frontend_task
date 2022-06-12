import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';

part 'price_list_state.dart';

class PriceListCubit extends Cubit<PriceListState> {
  PriceListCubit({
    required this.connectivity,
    required this.localRepository,
    required this.remoteRepository,
  }) : super(PriceListInitial());

  final Connectivity connectivity;
  final RemoteRepository remoteRepository;
  final LocalRepository localRepository;

  Future<void> getPriceList(String coinId) async {
    final ConnectivityResult connectivityStatus =
        await connectivity.checkConnectivity();
    if (connectivityStatus == ConnectivityResult.none) {
      print('get local prices');
      getLocalPriceList(coinId);
    } else {
      print('get remote price list');
      getRemotePriceList(coinId);
    }
  }

  Future<void> getRemotePriceList(String coinId) async {
    try {
      emit(PriceListLoading());
      final result = await remoteRepository.getRemoteCoinPriceHistory(coinId);
      emit(PriceListLoaded(prices: result.prices!));
    } catch (error) {
      emit(PriceListError());
    }
  }

  Future<void> getLocalPriceList(String coinId) async {
    try {
      emit(PriceListLoading());
      final result = await localRepository.getLocalCoinPriceList(coinId);
      emit(PriceListLoaded(prices: result));
    } catch (error) {
      emit(PriceListError());
    }
  }
}
