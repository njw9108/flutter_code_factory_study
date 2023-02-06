import 'package:code_factory/common/model/cursor_pagination_model.dart';
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
    final CursorPaginationBase data =
        context.watch<RestaurantProvider>().restaurantCursorPagination;

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return const Center(
        child: Text('에러입니다.'),
      );
    }

    //Cursor Pagination
    final cp = data as CursorPagination<RestaurantModel>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: builder(
        context,
        cp.data,
      ),
    );
  }
}
