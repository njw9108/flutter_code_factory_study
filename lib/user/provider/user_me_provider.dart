import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/repository/auth_repository.dart';
import 'package:code_factory/user/repository/user_me_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeProvider with ChangeNotifier {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeProvider({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) {
    print('get me call');
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
    print('get me ${resp.username}');
    notifyListeners();
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      userState = UserModelLoading();
      notifyListeners();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();
      userState = userResp;
      notifyListeners();

      return userResp;
    } catch (e) {
      userState = UserModelError(message: '로그인에 실패했습니다.');
      notifyListeners();
      return Future.value(userState);
    }
  }

  Future<void> logout() async {
    userState = null;
    notifyListeners();

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
