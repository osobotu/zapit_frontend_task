import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:zapit_frontend_task/constants.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';

class LocalRepository {
  LocalRepository();
  final coinsListBox = Hive.box(AppConstants.coinsListBox);
  final priceListBox = Hive.box(AppConstants.pricesListBox);

  Future<List<Coin>> getAllCoins() async {
    final localCoinsList = coinsListBox.get(AppConstants.coinsListKey);
    List<Coin> coins = [];
    for (var coinMap in localCoinsList) {
      final encode = jsonEncode(coinMap);
      final decode = jsonDecode(encode) as Map<String, dynamic>;
      coins.add(Coin.fromJson(decode));
    }
    return coins;
  }

  Future<void> updateLocalCoinsList({required List<Coin> coins}) async {
    List<Map<String, dynamic>> localCoinsList = [];

    for (var coin in coins) {
      localCoinsList.add(coin.toMap());
    }
    await coinsListBox.put(AppConstants.coinsListKey, localCoinsList);
  }

  Future<List<double>> getLocalCoinPriceList(String coinId) async {
    final priceList = priceListBox.get(coinId);
    return priceList;
  }

  Future<void> updateLocalPriceList(
      {required String coinId, required List<double> prices}) async {
    await priceListBox.put(coinId, prices);
  }
}
