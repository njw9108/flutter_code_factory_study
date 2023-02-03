import 'package:code_factory/common/model/cursor_pagination.dart';
import 'package:code_factory/common/model/pagination_params.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantRatingStateNotifier
    extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({
    required this.repository,
  }) : super(
          CursorPaginationLoading(),
        );


}
