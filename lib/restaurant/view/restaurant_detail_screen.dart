import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/dio/dio.dart';
import 'package:code_factory/common/layout/default_layout.dart';
import 'package:code_factory/product/component/product_card.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);

    final repository = RestaurantRepository(
      dio,
      baseUrl: 'http://$ip/restaurant',
    );

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: getRestaurantDetail(ref),
          builder: (context, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              slivers: [
                renderTop(
                  model: snapshot.data!,
                ),
                renderLabel(),
                renderProducts(
                  products: snapshot.data!.products,
                ),
              ],
            );
          }),
    );
  }

  Widget renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
