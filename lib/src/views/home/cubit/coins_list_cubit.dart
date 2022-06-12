import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';

part 'coins_list_state.dart';

class CoinsListCubit extends Cubit<CoinsListState> {
  CoinsListCubit({
    required this.connectivity,
    required this.remoteRepository,
    required this.localRepository,
  }) : super(CoinsListInitial());
  final Connectivity connectivity;
  final RemoteRepository remoteRepository;
  final LocalRepository localRepository;

  Future<void> getCoinsList() async {
    final ConnectivityResult connectivityStatus =
        await connectivity.checkConnectivity();
    if (connectivityStatus == ConnectivityResult.none) {
      print('get local');
      getLocalCoinsList();
    } else {
      print('get remote');
      getRemoteCoinsList();
    }
  }

  Future<void> getRemoteCoinsList() async {
    try {
      emit(CoinsListLoading());
      final result = await remoteRepository.getAllCoins();
      emit(CoinsListLoaded(coins: result));
    } catch (_) {
      emit(CoinsListError());
    }
  }

  Future<void> getLocalCoinsList() async {
    try {
      emit(CoinsListLoading());
      final result = await localRepository.getAllCoins();
      emit(CoinsListLoaded(coins: result));
    } catch (error) {
      print(error);
      emit(CoinsListError());
    }
  }
}
