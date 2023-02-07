import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/model/model_with_id.dart';
import 'package:code_factory/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? params = const PaginationParams(),
  });
}
