import 'package:flutter_test/flutter_test.dart';
import 'package:zapit_frontend_task/src/models/coin_price_history.dart';

void main() {
  test('CoinPriceHistory Model tests', () {
    final prices = [0.1, 0.2, 0.3];
    final coinPriceHistory = CoinPriceHistory(id: 'id', prices: prices);

    final map = coinPriceHistory.toMap();

    expect(map, {
      'id': 'id',
      'prices': prices,
    });

    expect(coinPriceHistory.props, ['id', prices]);
  });
}
