import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  const Coin({
    this.icon,
    this.id,
    this.name,
    this.price,
    this.priceBtc,
    this.priceChange1d,
    this.priceChange1h,
    this.priceChange1w,
    this.rank,
    this.symbol,
    this.websiteUrl,
    this.marketCap,
    this.volume,
  });

  final String? id;
  final String? icon;
  final String? name;
  final String? symbol;
  final int? rank;
  final double? price;
  final double? priceBtc;
  final double? priceChange1h;
  final double? priceChange1d;
  final double? priceChange1w;
  final String? websiteUrl;
  final double? marketCap;
  final double? volume;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        id: json['id'],
        icon: json['icon'],
        name: json['name'],
        symbol: json['symbol'],
        rank: json['rank'],
        price: json['price'] * 1.0,
        priceBtc: json['priceBtc'] * 1.0,
        priceChange1d: json['priceChange1d'] * 1.0,
        priceChange1h: json['priceChange1h'] * 1.0,
        priceChange1w: json['priceChange1w'] * 1.0,
        marketCap: json['marketCap'] * 1.0,
        volume: json['volume'] * 1.0,
        websiteUrl: json['websiteUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'symbol': symbol,
      'rank': rank,
      'price': price,
      'priceBtc': priceBtc,
      'priceChange1d': priceChange1d,
      'priceChange1h': priceChange1h,
      'priceChange1w': priceChange1w,
      'websiteUrl': websiteUrl,
      'volume': volume,
      'marketCap': marketCap,
    };
  }

  @override
  List<Object?> get props => [
        id,
        icon,
        name,
        rank,
        symbol,
        price,
        priceBtc,
        priceChange1d,
        priceChange1h,
        priceChange1w,
        websiteUrl,
        volume,
        marketCap,
      ];
}
