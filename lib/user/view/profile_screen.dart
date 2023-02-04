import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userMeProvider);
    final pState = state as UserModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(pState.imageUrl),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              pState.username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        const Spacer(),
        Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(userMeProvider.notifier).logout();
            },
            child: const Text('로그아웃'),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
