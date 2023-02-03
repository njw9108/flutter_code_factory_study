import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final pItem = data[index];

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
      ),
    );
  }
}
