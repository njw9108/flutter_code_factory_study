import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/layout/default_layout.dart';
import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/utils/pagination_utils.dart';
import 'package:code_factory/product/component/product_card.dart';
import 'package:code_factory/rating/component/rating_card.dart';
import 'package:code_factory/rating/model/rating_model.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<Dio, RestaurantRatingRepository>(
          update: (BuildContext context, value,
              RestaurantRatingRepository? previous) {
            final dio = context.watch<Dio>();
            final repository = RestaurantRatingRepository(
              dio,
              baseUrl: 'http://$ip/restaurant/$id/rating',
            );
            return repository;
          },
        ),
        ChangeNotifierProvider<RestaurantRatingProvider>(
          create: (context) {
            final repository = context.read<RestaurantRatingRepository>();
            return RestaurantRatingProvider(repository: repository);
          },
        ),
      ],
      child: RestaurantDetailScreenWidget(
        id: id,
      ),
    );
  }
}

class RestaurantDetailScreenWidget extends StatefulWidget {
  final String id;

  const RestaurantDetailScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RestaurantDetailScreenWidget> createState() =>
      _RestaurantDetailScreenWidgetState();
}

class _RestaurantDetailScreenWidgetState
    extends State<RestaurantDetailScreenWidget> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantProvider>().getDetail(id: widget.id);
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: context.read<RestaurantRatingProvider>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context
        .watch<RestaurantProvider>()
        .getRestaurantDetailModel(id: widget.id);

    final ratingData = context.watch<RestaurantRatingProvider>().cursorState;

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
        controller: controller,
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
          if (ratingData is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingData.data,
            ),
        ],
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
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
              child: ProductCard.fromRestaurantProductModel(model: model),
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
