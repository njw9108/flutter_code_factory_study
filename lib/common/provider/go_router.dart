import 'package:code_factory/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: provider.routes,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
