import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/provider/pagination_provider.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';

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

    return pState.data.firstWhereOrNull((element) => element.id == id);
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

    //데이터가 없을때는 그냥 캐시의 끝에다가 데이터를 추가한다.
    if (pState.data.where((e) => e.id == id).isEmpty) {
      cursorState = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      cursorState = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
            )
            .toList(),
      );
    }

    notifyListeners();
  }
}
