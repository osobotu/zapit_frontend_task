import 'package:equatable/equatable.dart';

class CoinPriceHistory extends Equatable {
  const CoinPriceHistory({this.id, this.prices});

  final String? id;
  final List<double>? prices;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prices': prices,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, prices];
}
