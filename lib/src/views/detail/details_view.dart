import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';

class DetailsView extends StatefulWidget {
  DetailsView({Key? key, required this.coin}) : super(key: key);

  final Coin coin;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.coin.name.toString(),
        ),
      ),
      body: ListView(
        children: [
          _BriefDetailsSection(
            imageUrl: widget.coin.icon,
            name: widget.coin.name,
            symbol: widget.coin.symbol,
            price: widget.coin.price,
            marketCap: widget.coin.marketCap,
            volume: widget.coin.volume,
          ),
          const SizedBox(height: 16),
          _DescriptionSection(
            symbol: widget.coin.symbol,
            priceChange1d: widget.coin.priceChange1d,
            priceChange1h: widget.coin.priceChange1h,
            priceChange1w: widget.coin.priceChange1w,
          )
        ],
      ),
    );
  }
}

class _BriefDetailsSection extends StatelessWidget {
  const _BriefDetailsSection(
      {Key? key,
      this.imageUrl,
      this.name,
      this.symbol,
      this.price,
      this.marketCap,
      this.volume})
      : super(key: key);

  final String? imageUrl;
  final String? name;
  final String? symbol;
  final double? price;
  final double? marketCap;
  final double? volume;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          width: 150,
          height: 200,
          imageUrl: imageUrl.toString(),
          placeholder: (context, _) {
            return Container(
              color: Colors.black12,
            );
          },
          maxHeightDiskCache: 100,
        ),
        Expanded(
            child: Column(
          children: [
            _DisplayItem(name: 'Name:', value: name.toString()),
            _DisplayItem(name: 'Symbol:', value: symbol.toString()),
            _DisplayItem(name: 'Price:', value: price.toString()),
            _DisplayItem(name: 'Market Cap:', value: marketCap.toString()),
            _DisplayItem(name: 'Volume:', value: volume.toString())
          ],
        ))
      ],
    );
  }
}

class _DisplayItem extends StatelessWidget {
  const _DisplayItem({Key? key, required this.name, required this.value})
      : super(key: key);
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({
    Key? key,
    this.priceChange1h,
    this.priceChange1d,
    this.priceChange1w,
    this.symbol,
  }) : super(key: key);

  final double? priceChange1h;
  final double? priceChange1d;
  final double? priceChange1w;
  final String? symbol;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Discussion: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '''In the last hour, price of $symbol has changed by $priceChange1h%. This may have been predicted from the estimated change in the last 24 hours - which sits at $priceChange1h%. Analyses from the last 7 days show that $symbol changed by $priceChange1w%.''',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
