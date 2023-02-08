import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/repository/user_me_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeProvider with ChangeNotifier {
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeProvider({
    required this.repository,
    required this.storage,
  }) {
    getMe();
  }

  UserModelBase? userState = UserModelLoading();

  //내정보 가져오기
  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      userState = null;
      notifyListeners();
      return;
    }
    final resp = await repository.getMe();
    userState = resp;
    notifyListeners();
  }
}
