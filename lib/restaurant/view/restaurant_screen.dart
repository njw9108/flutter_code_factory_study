import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  final AsyncSnapshot<CursorPagination<RestaurantModel>> restaurantModels;

  const RestaurantScreen({
    Key? key,
    required this.restaurantModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: restaurantModels.data!.data.length,
      itemBuilder: (_, index) {
        final pItem = restaurantModels.data!.data[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(
                  id: pItem.id,
                ),
              ),
            );
          },
          child: RestaurantCard.fromModel(
            model: pItem,
          ),
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: 16,
        );
      },
    );
  }
}
