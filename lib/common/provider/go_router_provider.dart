import 'package:code_factory/user/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

class GoRouterProvider {
  final AuthProvider provider;

  GoRouterProvider({
    required this.provider,
  }) {
    print('go router provider created');
    _router = GoRouter(
      routes: provider.routes,
      initialLocation: '/splash',
      refreshListenable: provider,
      redirect: provider.redirectLogic,
    );
  }

  late GoRouter _router;

  GoRouter get router => _router;
}
