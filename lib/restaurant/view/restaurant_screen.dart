import 'package:code_factory/common/component/pagination_list_view.dart';
import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: context.watch<RestaurantProvider>(),
      itemBuilder: <RestaurantModel>(_, index, model) {
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
                          baseUrl: 'http://$ip/restaurant/${model.id}/rating',
                        );
                        return repository;
                      },
                    ),
                    ChangeNotifierProvider<RestaurantRatingProvider>(
                      create: (context) {
                        final repository =
                            context.read<RestaurantRatingRepository>();
                        return RestaurantRatingProvider(repository: repository);
                      },
                    ),
                  ],
                  child: RestaurantDetailScreen(
                    id: model.id,
                  ),
                ),
              ),
            );
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
