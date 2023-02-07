import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/model/pagination_params.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantProvider({
    required this.repository,
  }) {
    paginate();
  }

  CursorPaginationBase cursorState = CursorPaginationLoading();

  RestaurantModel? getRestaurantDetail({required String id}) {
    if (cursorState is! CursorPagination) {
      return null;
    }

    final pState = cursorState as CursorPagination;

    return pState.data.firstWhere((element) => element.id == id);
  }

  Future<void> paginate({
    int fetchCount = 20,
    //true인 경우 추가로 데이터 더 가져오기,
    //false는 새로고침(현재상태를 덮어 씌움)
    bool fetchMore = false,
    //강제로 다시 로딩
    //true-CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      //5가지 가능성
      //State의 상태
      //상태가
      //1)CursorPagination - 정상적으로 데이터가 있는 상태

      //2)CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음 - forceRefetch)

      //3)CursorPaginationError - 에러가 있는 상태

      //4)CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터 가져올때

      //5)CursorPaginationFetchMore - 추가 데이터를 pagination 하라는 요청을 받았을때

      //바로 반환하는 상황
      //1) hasMore = false(기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
      //2) 로딩중 - featchMore가 true일때(추가 데이터를 가져오는 상황)
      //        - fetchMore가 false일때는 기존 요청을 멈추고 새로고침을 한다.
      if (cursorState is CursorPagination<RestaurantModel> &&
          !forceRefetch) {
        final pState =
            cursorState as CursorPagination<RestaurantModel>;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      //3가지 로딩 상태
      final isLoading = cursorState is CursorPaginationLoading;
      final isRefetching =
          cursorState is CursorPaginationRefetching;
      final isFetchingMore =
          cursorState is CursorPaginationFetchingMore;

      //2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // Pagination Params 생성
      PaginationParams params = PaginationParams(count: fetchCount);

      // fetching More 상황
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = cursorState as CursorPagination;

        cursorState = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        notifyListeners();

        params = params.copyWith(
          after: pState.data.last.id,
        );
      }
      //데이터를 처음부터 가져오는 상황
      else {
        //만약 데이터가 있는 상황이라면
        //기존 데이터를 보존한채로 Fetch(API요청) 진행
        if (cursorState is CursorPagination && !forceRefetch) {
          final pState = cursorState as CursorPagination;

          cursorState = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
          notifyListeners();
        } else {
          //나머지 상황
          cursorState = CursorPaginationLoading();
          notifyListeners();
        }
      }

      final resp = await repository.paginate(
        params: params,
      );

      if (cursorState is CursorPaginationFetchingMore) {
        final pState =
            cursorState as CursorPaginationFetchingMore;

        //기존 데이터에 새로운 데이터 추가
        cursorState = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
        notifyListeners();
      } else {
        cursorState = resp;
        notifyListeners();
      }
    } catch (e) {
      cursorState =
          CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
      notifyListeners();
    }
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
