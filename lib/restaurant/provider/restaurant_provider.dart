import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/provider/pagination_provider.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';

class RestaurantProvider
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantProvider({
    required super.repository,
  });

  RestaurantModel? getRestaurantDetailModel({required String id}) {
    if (cursorState is! CursorPagination) {
      return null;
    }

    final pState = cursorState as CursorPagination;

    return pState.data.firstWhere((element) => element.id == id);
  }

  Future<void> getDetail({required String id}) async {
    // 아직 데이터가 하나도 없는 상태라 (state가 CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (cursorState is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐때 그냥 리턴
    if (cursorState is! CursorPagination) {
      return;
    }

    final pState = cursorState as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    cursorState = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
    notifyListeners();
  }
}
