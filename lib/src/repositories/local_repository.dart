import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:zapit_frontend_task/constants.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';

class LocalRepository {
  LocalRepository();

  final coinsListBox = Hive.box(AppConstants.coinsListBox);

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
}
