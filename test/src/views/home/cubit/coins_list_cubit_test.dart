import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';
import 'package:zapit_frontend_task/src/views/home/cubit/coins_list_cubit.dart';

// mock our dependencies
class MockConnectivity extends Mock implements Connectivity {}

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockRemoteRepository mockRemoteRepository;
  late MockLocalRepository mockLocalRepository;
  late CoinsListCubit coinsListCubit;

  setUp(
    () {
      mockConnectivity = MockConnectivity();
      mockRemoteRepository = MockRemoteRepository();
      mockLocalRepository = MockLocalRepository();
      coinsListCubit = CoinsListCubit(
        connectivity: mockConnectivity,
        remoteRepository: mockRemoteRepository,
        localRepository: mockLocalRepository,
      );
    },
  );

  tearDown(() {
    coinsListCubit.close();
  });

  test('cubit should have initial state as [CoinsListInitial]', () {
    expect(coinsListCubit.state.runtimeType, CoinsListInitial);
  });

  group(
    'getCoinsList()',
    () {
      const List<Coin> testCoins = [
        Coin(
          id: 'id1',
          name: 'name1',
          icon: 'icon1',
          symbol: 'symbol1',
          rank: 1,
          price: 1.0,
          priceBtc: 1.0,
          priceChange1h: 1.0,
          priceChange1d: 1.0,
          priceChange1w: 1.0,
          websiteUrl: 'websiteUrl1',
          marketCap: 1.0,
          volume: 1.0,
        ),
        Coin(
          id: 'id2',
          name: 'name2',
          icon: 'icon2',
          symbol: 'symbol2',
          rank: 2,
          price: 2.0,
          priceBtc: 2.0,
          priceChange1h: 2.0,
          priceChange1d: 2.0,
          priceChange1w: 2.0,
          websiteUrl: 'websiteUrl2',
          marketCap: 2.0,
          volume: 2.0,
        ),
        Coin(
          id: 'id3',
          name: 'name3',
          icon: 'icon3',
          symbol: 'symbol3',
          rank: 3,
          price: 3.0,
          priceBtc: 3.0,
          priceChange1h: 3.0,
          priceChange1d: 3.0,
          priceChange1w: 3.0,
          websiteUrl: 'websiteUrl3',
          marketCap: 3.0,
          volume: 3.0,
        ),
      ];

      blocTest<CoinsListCubit, CoinsListState>(
        'emits [CoinsListLoading, CoinsListLoaded] when'
        'getAllCoins() in remote repository is called successfully'
        'using mobile connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.mobile);
          when(() => mockRemoteRepository.getAllCoins())
              .thenAnswer((_) async => testCoins);
        },
        build: () => coinsListCubit,
        act: (cubit) => cubit.getCoinsList(),
        expect: () => <CoinsListState>[
          CoinsListLoading(),
          CoinsListLoaded(coins: testCoins)
        ],
        verify: (_) async {
          verify(() => mockRemoteRepository.getAllCoins()).called(1);
          verifyNever(() => mockLocalRepository.getAllCoins());
        },
      );

      blocTest<CoinsListCubit, CoinsListState>(
        'emits [CoinsListLoading, CoinsListLoaded] when'
        'getAllCoins() in remote repository is called successfully'
        'using wifi connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.wifi);
          when(() => mockRemoteRepository.getAllCoins())
              .thenAnswer((_) async => testCoins);
        },
        build: () => coinsListCubit,
        act: (cubit) => cubit.getCoinsList(),
        expect: () => <CoinsListState>[
          CoinsListLoading(),
          CoinsListLoaded(coins: testCoins)
        ],
        verify: (_) async {
          verify(() => mockRemoteRepository.getAllCoins()).called(1);
          verifyNever(() => mockLocalRepository.getAllCoins());
        },
      );

      blocTest<CoinsListCubit, CoinsListState>(
        'emits [CoinsListLoading, CoinsListError] when'
        'getAllCoins() in remote repository failed,'
        'with no internet connection',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.none);
          when(() => mockRemoteRepository.getAllCoins())
              .thenThrow(CoinsListError());
        },
        build: () => coinsListCubit,
        act: (cubit) => cubit.getCoinsList(),
        expect: () => <CoinsListState>[
          CoinsListLoading(),
          CoinsListError(),
        ],
        verify: (_) async {
          verifyNever(() => mockRemoteRepository.getAllCoins());
        },
      );

      blocTest<CoinsListCubit, CoinsListState>(
        'emits [CoinsListLoading, CoinsListLoaded] when'
        'there is no internet connection, then getAllCoins()'
        'in local repository is successful',
        setUp: () {
          when(() => mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.none);
          when(() => mockLocalRepository.getAllCoins())
              .thenAnswer((_) async => testCoins);
        },
        build: () => coinsListCubit,
        act: (cubit) => cubit.getCoinsList(),
        expect: () => <CoinsListState>[
          CoinsListLoading(),
          CoinsListLoaded(coins: testCoins)
        ],
        verify: (_) async {
          verifyNever(() => mockRemoteRepository.getAllCoins());
          verify(() => mockLocalRepository.getAllCoins()).called(1);
        },
      );
    },
  );
}
