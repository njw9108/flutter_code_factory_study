import 'package:code_factory/common/view/root_tab.dart';
import 'package:code_factory/common/view/splash_screen.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:code_factory/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  final UserMeProvider userMeProvider;
  UserModelBase? prevUserMeState = UserModelLoading();

  AuthProvider({
    required this.userMeProvider,
  }) {
    print('auth provider created');
    userMeProvider.addListener(userMeListener);
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, state) => const RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                builder: (_, state) => RestaurantDetailScreen(
                  id: state.params['rid']!,
                ),
              ),
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, state) => const LoginScreen(),
        ),
      ];

  @override
  void dispose() {
    userMeProvider.removeListener(userMeListener);
    super.dispose();
  }

  void userMeListener() {
    if (prevUserMeState != userMeProvider.userState) {
      print('user me provider changed');
      print('prev : $prevUserMeState');
      print('current : ${userMeProvider.userState}');
      prevUserMeState = userMeProvider.userState;
      notifyListeners();
    }
  }

  //splash screen
  //앱을 처음 시작했을때 토큰이 존재하는지 확인하고
  //로그인 스크린으로 보낼지 홈 스크린으로 보낼지 확인하는 과정이필요하다
  String? redirectLogin(BuildContext context, GoRouterState state) {
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
