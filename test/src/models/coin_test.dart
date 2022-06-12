import 'package:flutter_test/flutter_test.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';

void main() {
  group(
    'Coin Model tests',
    () {
      final json = {
        'id': 'id',
        'icon': 'icon',
        'name': 'name',
        'symbol': 'symbol',
        'rank': 1,
        'price': 1.0,
        'priceBtc': 1.0,
        'priceChange1h': 1.0,
        'priceChange1d': 1.0,
        'priceChange1w': 1.0,
        'marketCap': 1.0,
        'websiteUrl': 'websiteUrl',
      };

      final coin = Coin.fromJson(json);

      final map = coin.toMap();
      test(
        'Coin.fromJson() should take a Map<String, dynamic> and return a Coin object',
        () {
          expect(
            coin.props,
            [
              'id',
              'icon',
              'name',
              1,
              'symbol',
              1.0,
              1.0,
              1.0,
              1.0,
              1.0,
              'websiteUrl',
              1.0
            ],
          );
        },
      );

      test('toMap() takes a Coin object and returns a Map<String, dynamic>',
          () {
        expect(map, json);
      });
    },
  );
}
