class CoinPriceHistory {
  CoinPriceHistory({this.id, this.prices});

  final String? id;
  final List<double>? prices;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prices': prices,
    };
  }
}
