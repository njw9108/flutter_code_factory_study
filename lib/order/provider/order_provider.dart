import 'package:code_factory/order/model/order_product_model.dart';
import 'package:code_factory/order/model/post_order_body.dart';
import 'package:code_factory/order/repository/order_repository.dart';
import 'package:code_factory/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(
    ref: ref,
    repository: repository,
  );
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final String id = uuid.v4();
      final state = ref.read(basketProvider);
      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: state.fold<int>(
            0,
            (p, n) => p + (n.count * n.product.price),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e,stack) {
      print(e);
      print(stack);
      return false;
    }
  }
}
