import 'package:code_factory/common/provider/pagination_provider.dart';
import 'package:code_factory/product/model/product_model.dart';
import 'package:code_factory/product/repository/product_repository.dart';

class ProductProvider
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductProvider({
    required super.repository,
  });
}
