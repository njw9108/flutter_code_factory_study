import 'package:code_factory/user/provider/user_login_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<UserLoginStateProvider>().logout();
          },
          child: Text('로그아웃'),
        ),
      ],
    );
  }
}
