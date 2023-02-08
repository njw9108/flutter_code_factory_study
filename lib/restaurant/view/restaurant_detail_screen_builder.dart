import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantDetailScreenBuilder extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailScreenBuilder({
    Key? key,
    required this.restaurantId,
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
              baseUrl: 'http://$ip/restaurant/$restaurantId/rating',
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
      child: RestaurantDetailScreen(
        id: restaurantId,
      ),
    );
  }
}
