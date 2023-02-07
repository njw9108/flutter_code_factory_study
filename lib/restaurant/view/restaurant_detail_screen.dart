import 'package:code_factory/common/layout/default_layout.dart';
import 'package:code_factory/product/component/product_card.dart';
import 'package:code_factory/rating/component/rating_card.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantProvider>().getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final model = provider.getRestaurantDetail(id: widget.id);

    if (model == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: model.name,
      child: CustomScrollView(
        slivers: [
          renderTop(
            model: model,
          ),
          if (model is! RestaurantDetailModel) renderLoading(),
          if (model is RestaurantDetailModel) renderLabel(),
          if (model is RestaurantDetailModel)
            renderProducts(
              products: model.products,
            ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: RatingCard(
                avatarImage: AssetImage('asset/img/logo/codefactory_logo.png'),
                images: [],
                rating: 4,
                email: 'njw9108@naver.com',
                content: '맛있습니다.',
              ),
            ),
          )
        ],
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  lines: 4,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
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
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
