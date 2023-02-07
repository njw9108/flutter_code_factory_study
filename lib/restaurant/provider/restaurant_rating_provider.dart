import 'package:code_factory/common/provider/pagination_provider.dart';
import 'package:code_factory/rating/model/rating_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingProvider
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingProvider({
    required super.repository,
  });
}
