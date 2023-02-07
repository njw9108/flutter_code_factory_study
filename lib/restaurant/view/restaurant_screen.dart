import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/utils/pagination_utils.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final controller = ScrollController();

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
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
      provider: context.read<RestaurantProvider>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<RestaurantProvider>().cursorState;

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터 입니다.'),
              ),
            );
          }
          final pItem = cp.data[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ProxyProvider<Dio, RestaurantRatingRepository>(
                        update: (BuildContext context, value,
                            RestaurantRatingRepository? previous) {
                          final dio = context.watch<Dio>();
                          final repository = RestaurantRatingRepository(
                            dio,
                            baseUrl: 'http://$ip/restaurant/${pItem.id}/rating',
                          );
                          return repository;
                        },
                      ),
                      ChangeNotifierProvider<RestaurantRatingProvider>(
                        create: (context) {
                          final repository =
                              context.read<RestaurantRatingRepository>();
                          return RestaurantRatingProvider(
                              repository: repository);
                        },
                      ),
                    ],
                    child: RestaurantDetailScreen(
                      id: pItem.id,
                    ),
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 16,
          );
        },
      ),
    );
  }
}
