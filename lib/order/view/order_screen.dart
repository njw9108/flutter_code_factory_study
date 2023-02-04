import 'package:code_factory/common/component/pagination_list_view.dart';
import 'package:code_factory/order/component/order_card.dart';
import 'package:code_factory/order/model/order_product_model.dart';
import 'package:code_factory/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(
          model: model,
        );
      },
    );
  }
}
