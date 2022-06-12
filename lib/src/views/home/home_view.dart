import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapit_frontend_task/src/models/coin.dart';
import 'package:zapit_frontend_task/src/repositories/local_repository.dart';
import 'package:zapit_frontend_task/src/repositories/remote_repository.dart';
import 'package:zapit_frontend_task/src/utils/network_aware_mixin.dart';
import 'package:zapit_frontend_task/src/views/detail/details_view.dart';
import 'package:zapit_frontend_task/src/views/home/cubit/coins_list_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with NetworkAwareMixin {
  late final CoinsListCubit coinsListCubit;
  late final RemoteRepository _remoteRepository;
  late final LocalRepository _localRepository;
  late final Connectivity _connectivity;

  @override
  void initState() {
    _remoteRepository = RemoteRepository();
    _localRepository = LocalRepository();
    _connectivity = Connectivity();

    coinsListCubit = CoinsListCubit(
      remoteRepository: _remoteRepository,
      connectivity: _connectivity,
      localRepository: _localRepository,
    );

    coinsListCubit.getCoinsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zapit Frontend Task')),
      body: BlocConsumer(
        bloc: coinsListCubit,
        builder: (context, state) {
          if (state is CoinsListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CoinsListLoaded) {
            return _ImageGridSection(
              coins: state.coins,
            );
          }
          if (state is CoinsListError) {
            return const Center(
              child: Text('Error occurred!'),
            );
          }
          return const SizedBox();
        },
        listener: (context, state) {
          if (state is CoinsListLoaded) {
            _localRepository.updateLocalCoinsList(coins: state.coins);
          }
        },
      ),
    );
  }
}

class _ImageGridSection extends StatelessWidget {
  const _ImageGridSection({Key? key, required this.coins}) : super(key: key);
  final List<Coin> coins;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: coins.length,
      itemBuilder: (context, index) {
        Coin coin = coins[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return DetailsView(
                  coin: coin,
                );
              }),
            );
          },
          child: CachedNetworkImage(
            imageUrl: coin.icon.toString(),
            placeholder: (context, _) {
              return Container(
                color: Colors.black12,
              );
            },
            maxHeightDiskCache: 100,
          ),
        );
      },
    );
  }
}
