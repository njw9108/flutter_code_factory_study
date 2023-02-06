import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatefulWidget {
  final List<RestaurantModel> restaurantModels;

  const RestaurantScreen({
    Key? key,
    required this.restaurantModels,
  }) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final controller = ScrollController();

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      context.read<RestaurantProvider>().paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: widget.restaurantModels.length,
      itemBuilder: (_, index) {
        final pItem = widget.restaurantModels[index];

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
