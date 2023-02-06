import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreenBuilder extends StatelessWidget {
  final Widget Function(
      BuildContext, AsyncSnapshot<CursorPagination<RestaurantModel>>) builder;

  const RestaurantScreenBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<CursorPagination<RestaurantModel>>(
          future: context.watch<RestaurantRepository>().paginate(),
          builder: (context,
              AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return builder(
              context,
              snapshot,
            );
          },
        ),
      ),
    );
  }
}
