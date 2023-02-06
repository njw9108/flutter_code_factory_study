import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/cupertino.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantProvider({
    required this.repository,
  }) {
    paginate();
  }

  CursorPagination<RestaurantModel> restaurants = CursorPagination();

  Future<void> paginate() async {
    final resp = await repository.paginate();

    restaurants = resp.data;
    notifyListeners();
  }
}
