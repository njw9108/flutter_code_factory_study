import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';

class RestaurantScreenBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<RestaurantModel>) builder;

  const RestaurantScreenBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<RestaurantModel> data =
        context.watch<RestaurantProvider>().restaurants;

    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: builder(
        context,
        data,
      ),
    );
  }
}
