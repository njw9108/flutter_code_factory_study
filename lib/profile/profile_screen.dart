import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read()<UserMeProvider>().logout();
        },
        child: Text('로그아웃'),
      ),
    );
  }
}
