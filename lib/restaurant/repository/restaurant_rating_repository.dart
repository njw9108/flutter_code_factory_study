import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/model/pagination_params.dart';
import 'package:code_factory/common/repository/base_pagination_repository.dart';
import 'package:code_factory/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

@RestApi()
abstract class RestaurantRatingRepository
    extends IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? params = const PaginationParams(),
  });
}
