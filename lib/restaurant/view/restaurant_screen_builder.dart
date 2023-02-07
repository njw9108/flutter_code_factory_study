import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';

class RestaurantScreenBuilder extends StatelessWidget {
  final Widget Function(BuildContext, CursorPaginationBase) builder;

  const RestaurantScreenBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data =
        context.watch<RestaurantProvider>().cursorState;

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

    //Cursor Pagination
    //Cursor PaginationFetchingMore
    //Cursor PaginationRefetching

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: builder(
        context,
        data,
      ),
    );
  }
}
