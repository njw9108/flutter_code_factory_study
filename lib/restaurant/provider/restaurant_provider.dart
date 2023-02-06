import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/cupertino.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantProvider({
    required this.repository,
  }) {
    paginate();
  }

  CursorPaginationBase restaurants = CursorPaginationLoading();

  Future<void> paginate({
    int fetchCount = 20,
    //true인 경우 추가로 데이터 더 가져오기,
    //false는 새로고침(현재상태를 덮어 씌움)
    bool fetchMore = false,
    //강제로 다시 로딩
    //true-CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    //5가지 가능성
    //State의 상태
    //상태가
    //1)CursorPagination - 정상적으로 데이터가 있는 상태

    //2)CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음 - forceRefetch)

    //3)CursorPaginationError - 에러가 있는 상태

    //4)CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터 가져올때

    //5)CursorPaginationFetchMore - 추가 데이터를 pagination 하라는 요청을 받았을때


    notifyListeners();
  }
}
