import 'package:code_factory/common/view/root_tab.dart';
import 'package:code_factory/common/view/splash_screen.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:code_factory/user/model/user_model.dart';
import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:code_factory/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, state) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.params['rid']!,
              ),
            ),
          ],
        ),
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

  //splashScreen
  //앱을 처은 시작햇을때 토큰이 존재하는지 확인하고 로그인 스크린으로 보낼지
  //홈 스크린으로 보낼지 확이하는 과정이 필요하다.
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final loggingIn = state.location == '/login';

    //유저 정보가 없는데 로그인 중이면 로그인 페이지에 두고
    //로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    //유저가 null이 아님

    //usermodel인 상태
    //사용자 정보가 있는 상태면
    //로그인 중이거나 현재 위치가 splash screen 이면
    // 홈으로 이동
    if (user is UserModel) {
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    //UserModelError
    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    return null;
  }
}
