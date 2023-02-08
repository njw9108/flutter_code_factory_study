import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  UserMeProvider userMeProvider;

  AuthProvider({
    required this.userMeProvider,
  }) {
    userMeProvider.addListener(userMeListener);
  }

  @override
  void dispose() {
    print('auth provider disposed');
    userMeProvider.removeListener(userMeListener);
    super.dispose();
  }

  void userMeListener() {
    print('user me provider changed');
  }

  //splash screen
  //앱을 처음 시작했을때 토큰이 존재하는지 확인하고
  //로그인 스크린으로 보낼지 홈 스크린으로 보낼지 확인하는 과정이필요하다
  String? redirectLogin(GoRouterState state) {
    final UserModelBase? user = userMeProvider.userState;

    final loggingIn = state.location == '/login';

    //유저 정보가 없는데 로그인 중이라면 그대로 로그인 페이지에 두고
    //만약 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    //user가 null이 아님

    //usermodel(사용자 정보가 있음)
    //로그인 중이거나 현재 위치가 Splash Screen -> 홈으로 이동
    if (user is UserModel) {
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    //user model error
    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    return null;
  }
}
