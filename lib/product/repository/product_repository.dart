import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/model/pagination_params.dart';
import 'package:code_factory/common/repository/base_pagination_repository.dart';
import 'package:code_factory/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'product_repository.g.dart';

@RestApi()
abstract class ProductRepository
    implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? params = const PaginationParams(),
  });
}
