import 'package:code_factory/common/model/cursor_pagination.dart';
import 'package:code_factory/common/provider/pagination_provider.dart';
import 'package:code_factory/product/model/product_model.dart';
import 'package:code_factory/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
