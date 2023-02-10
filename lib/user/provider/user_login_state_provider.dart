import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLoginStateProvider with ChangeNotifier {
  final FlutterSecureStorage storage;

  UserLoginStateProvider({
    required this.storage,
  });

  UserModelBase? _userState = UserModelLoading();

  UserModelBase? get userState => _userState;

  void setUserState(UserModelBase? userState) {
    _userState = userState;
    notifyListeners();
  }

  Future<void> logout() async {
    setUserState(null);

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
