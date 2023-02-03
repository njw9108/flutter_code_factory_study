import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/restaurant/component/restaurant_card.dart';
import 'package:code_factory/restaurant/model/restaurant_model.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<CursorPaginationModel<RestaurantModel>>(
          future: ref.watch(restaurantRepositoryProvider).paginate(),
          builder: (context,
              AsyncSnapshot<CursorPaginationModel<RestaurantModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (_, index) {
                final pItem = snapshot.data!.data[index];

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
          },
        ),
      ),
    );
  }
}
