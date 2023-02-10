import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/provider/user_login_state_provider.dart';
import 'package:code_factory/user/repository/auth_repository.dart';
import 'package:code_factory/user/repository/user_me_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeProvider {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;
  final UserLoginStateProvider userLoginStateProvider;

  UserMeProvider({
    required this.authRepository,
    required this.repository,
    required this.storage,
    required this.userLoginStateProvider,
  }) {
    getMe();
  }

  //내정보 가져오기
  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      userLoginStateProvider.setUserState(null);
      //notifyListeners();
      return;
    }
    final resp = await repository.getMe();
    userLoginStateProvider.setUserState(resp);
    //notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      userLoginStateProvider.setUserState(UserModelLoading());
      //notifyListeners();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();
      userLoginStateProvider.setUserState(userResp);
      //notifyListeners();
    } catch (e) {
      userLoginStateProvider
          .setUserState(UserModelError(message: '로그인에 실패했습니다.'));
      //notifyListeners();
    }
  }
}
