import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zapit_frontend_task/constants.dart';
import 'package:zapit_frontend_task/src/models/coin_price_history.dart';

import '../models/coin.dart';

class RemoteRepository {
  RemoteRepository();

  final dio = Dio();
  static const String COINS_LIST_API_URL =
      'https://api.coinstats.app/public/v1/coins';

  static const String COIN_PRICE_HISTORY =
      'https://api.coinstats.app/public/v1/charts';

  Future<List<Coin>> getAllCoins() async {
    late final List<Coin> coins = [];
    try {
      Response response = await dio.get(COINS_LIST_API_URL);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        final coinsData = response.data['coins'] as List;
        for (var coin in coinsData) {
          coins.add(Coin.fromJson(coin));
        }
      }
    } on DioError catch (_) {
      final coinsListBox = Hive.box(AppConstants.coinsListBox);
      final localCoinsList = coinsListBox.get(AppConstants.coinsListKey);
      for (var coinMap in localCoinsList) {
        coins.add(Coin.fromJson(coinMap));
      }
    } catch (err, st) {
      print(err);
      print(st);
    }
    return coins;
  }

  Future<CoinPriceHistory> getRemoteCoinPriceHistory(String coinId) async {
    late final CoinPriceHistory coinPriceHistory;
    Map<String, dynamic> queryParams = {
      'period': '1m',
      'coinId': coinId,
    };

    try {
      Response response =
          await dio.get(COIN_PRICE_HISTORY, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final chartsData = response.data['chart'] as List;

        List<double> prices = [];
        for (var item in chartsData) {
          prices.add(item[1] * 0.1);
        }
        coinPriceHistory = CoinPriceHistory(id: coinId, prices: prices);
      }
    } on DioError catch (_) {
      // get data from local db
      final priceListBox = Hive.box(AppConstants.pricesListBox);
      final prices = priceListBox.get(coinId);
      coinPriceHistory = CoinPriceHistory(id: coinId, prices: prices);
    } catch (err, st) {
      print(err);
      print(st);
    }
    return coinPriceHistory;
  }
}
