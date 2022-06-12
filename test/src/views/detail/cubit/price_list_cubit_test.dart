import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zapit_frontend_task/src/models/coin_price_history.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';
import 'package:zapit_frontend_task/src/views/detail/cubit/price_list_cubit.dart';

// mock our dependencies
class MockConnectivity extends Mock implements Connectivity {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockRemoteRepository mockRemoteRepository;
  late MockLocalRepository mockLocalRepository;
  late PriceListCubit priceListCubit;

  setUp(
    () {
      mockConnectivity = MockConnectivity();
      mockRemoteRepository = MockRemoteRepository();
      mockLocalRepository = MockLocalRepository();
      priceListCubit = PriceListCubit(
        connectivity: mockConnectivity,
        remoteRepository: mockRemoteRepository,
        localRepository: mockLocalRepository,
      );
    },
  );

  tearDown(() {
    priceListCubit.close();
  });

  test('cubit should have initial state as [PriceListInitial]', () {
    expect(priceListCubit.state.runtimeType, PriceListInitial);
  });

  group(
    'getPriceList()',
    () {
      const coinId = 'btc';
      const prices = [0.1, 0.2, 0.3, 0.4, 0.5];

      final result = CoinPriceHistory(id: coinId, prices: prices);

      blocTest<PriceListCubit, PriceListState>(
        'emits [PriceListLoading, PriceListLoaded] when'
        'getRemotePriceList(coinId) is called successfully'
        'using mobile connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.mobile);
          when(() => mockRemoteRepository.getRemoteCoinPriceHistory(coinId))
              .thenAnswer((_) async => result);
        },
        build: () => priceListCubit,
        act: (PriceListCubit cubit) => cubit.getPriceList(coinId),
        expect: () => <PriceListState>[
          PriceListLoading(),
          PriceListLoaded(prices: result.prices!),
        ],
        verify: (_) async {
          verify(() => mockRemoteRepository.getRemoteCoinPriceHistory(coinId))
              .called(1);
        },
      );

      blocTest<PriceListCubit, PriceListState>(
        'emits [PriceListLoading, PriceListLoaded] when'
        'getRemotePriceList(coinId) is called successfully'
        'using wifi connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.wifi);
          when(() => mockRemoteRepository.getRemoteCoinPriceHistory(coinId))
              .thenAnswer((_) async => result);
        },
        build: () => priceListCubit,
        act: (PriceListCubit cubit) => cubit.getPriceList(coinId),
        expect: () => <PriceListState>[
          PriceListLoading(),
          PriceListLoaded(prices: result.prices!),
        ],
        verify: (_) async {
          verify(() => mockRemoteRepository.getRemoteCoinPriceHistory(coinId))
              .called(1);
        },
      );

      blocTest<PriceListCubit, PriceListState>(
        'emits [PriceListLoading, PriceListError] when'
        'getRemotePriceList(coinId) failed with'
        'no internet connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.none);
          when(() => mockRemoteRepository.getRemoteCoinPriceHistory(coinId))
              .thenThrow(PriceListError());
        },
        build: () => priceListCubit,
        act: (PriceListCubit cubit) => cubit.getPriceList(coinId),
        expect: () => <PriceListState>[
          PriceListLoading(),
          PriceListError(),
        ],
        verify: (_) async {
          verifyNever(
              () => mockRemoteRepository.getRemoteCoinPriceHistory(coinId));
        },
      );

      blocTest<PriceListCubit, PriceListState>(
        'emits [PriceListLoading, PriceListLoaded] when'
        'getRemotePriceList(coinId) failed with no internet '
        'connection and getLocalPriceList() is called successfully',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.none);
          when(() => mockLocalRepository.getLocalCoinPriceList(coinId))
              .thenAnswer((_) async => prices);
        },
        build: () => priceListCubit,
        act: (PriceListCubit cubit) => cubit.getPriceList(coinId),
        expect: () => <PriceListState>[
          PriceListLoading(),
          PriceListLoaded(prices: prices),
        ],
        verify: (_) async {
          verifyNever(
              () => mockRemoteRepository.getRemoteCoinPriceHistory(coinId));
          verify(() => mockLocalRepository.getLocalCoinPriceList(coinId));
        },
      );
    },
  );
}
