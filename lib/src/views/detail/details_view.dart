import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';
import 'package:zapit_frontend_task/src/utils/network_aware_mixin.dart';
import 'package:zapit_frontend_task/src/views/detail/cubit/price_list_cubit.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({Key? key, required this.coin}) : super(key: key);

  final Coin coin;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> with NetworkAwareMixin {
  late final PriceListCubit priceListCubit;
  late final RemoteRepository _remoteRepository;
  late final LocalRepository _localRepository;
  late final Connectivity _connectivity;

  @override
  void initState() {
    _remoteRepository = RemoteRepository();
    _localRepository = LocalRepository();
    _connectivity = Connectivity();

    priceListCubit = PriceListCubit(
      remoteRepository: _remoteRepository,
      connectivity: _connectivity,
      localRepository: _localRepository,
    );

    priceListCubit.getPriceList(widget.coin.id.toString());

    super.initState();
  }

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
          ),
          const SizedBox(height: 16),
          _DescriptionSection(
            symbol: widget.coin.symbol,
            priceChange1d: widget.coin.priceChange1d,
            priceChange1h: widget.coin.priceChange1h,
            priceChange1w: widget.coin.priceChange1w,
          ),
          const SizedBox(height: 16),
          BlocConsumer(
            bloc: priceListCubit,
            builder: (context, state) {
              if (state is PriceListLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PriceListLoaded) {
                return Center(
                  child: _PricePlotSection(prices: state.prices),
                );
              }
              if (state is PriceListError) {
                return const Center(
                  child: Text('Error occurred!'),
                );
              }
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is PriceListLoaded) {
                _localRepository.updateLocalPriceList(
                    coinId: widget.coin.id.toString(), prices: state.prices);
              }
            },
          )
        ],
      ),
    );
  }
}

class _BriefDetailsSection extends StatelessWidget {
  const _BriefDetailsSection({
    Key? key,
    this.imageUrl,
    this.name,
    this.symbol,
    this.price,
    this.marketCap,
  }) : super(key: key);

  final String? imageUrl;
  final String? name;
  final String? symbol;
  final double? price;
  final double? marketCap;

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

class _PricePlotSection extends StatelessWidget {
  const _PricePlotSection({Key? key, required this.prices}) : super(key: key);

  final List<double> prices;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.blueGrey.withOpacity(0.15),
      width: size.width * 0.9,
      height: size.height * 0.4,
      child: LineChart(
        LineChartData(
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.black45,
                spots: List.generate(
                  prices.length,
                  (index) => FlSpot(index.toDouble(), prices[index]),
                ),
              )
            ],
            gridData: FlGridData(
              show: false,
            )),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }
}
