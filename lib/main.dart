import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/dio/dio.dart';
import 'package:code_factory/common/provider/go_router_provider.dart';
import 'package:code_factory/product/provider/product_provider.dart';
import 'package:code_factory/product/repository/product_repository.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory/user/provider/auth_provider.dart';
import 'package:code_factory/user/provider/user_login_state_provider.dart';
import 'package:code_factory/user/provider/user_me_provider.dart';
import 'package:code_factory/user/repository/auth_repository.dart';
import 'package:code_factory/user/repository/user_me_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        ChangeNotifierProxyProvider<FlutterSecureStorage,
            UserLoginStateProvider?>(
          create: (context) => null,
          update: (context, storage, UserLoginStateProvider? previous) {
            if (previous == null) {
              return UserLoginStateProvider(storage: storage);
            } else {
              return previous;
            }
          },
        ),
        ProxyProvider2<FlutterSecureStorage, UserLoginStateProvider, Dio>(
          update: (BuildContext context, storage, userLoginStateProvider,
              Dio? previous) {
            if (previous == null) {
              final dio = Dio();
              dio.interceptors.add(
                CustomInterceptor(
                  storage: storage,
                  userLoginStateProvider: userLoginStateProvider,
                ),
              );
              return dio;
            } else {
              return previous;
            }
          },
        ),
        ProxyProvider<Dio, RestaurantRepository>(
          update:
              (BuildContext context, value, RestaurantRepository? previous) {
            if (previous == null) {
              final dio = context.read<Dio>();
              final repository =
                  RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
              return repository;
            } else {
              return previous;
            }
          },
        ),
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) {
            final repository = context.read<RestaurantRepository>();
            return RestaurantProvider(repository: repository);
          },
        ),
        ProxyProvider<Dio, ProductRepository>(
          update: (BuildContext context, value, ProductRepository? previous) {
            if (previous == null) {
              final dio = context.read<Dio>();
              final repository =
                  ProductRepository(dio, baseUrl: 'http://$ip/product');
              return repository;
            } else {
              return previous;
            }
          },
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) {
            final repository = context.read<ProductRepository>();
            return ProductProvider(repository: repository);
          },
        ),
        ProxyProvider<Dio, UserMeRepository>(
          update: (BuildContext context, value, UserMeRepository? previous) {
            if (previous == null) {
              final dio = context.read<Dio>();
              final repository =
                  UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
              return repository;
            } else {
              return previous;
            }
          },
        ),
        ProxyProvider<Dio, AuthRepository>(
          update: (BuildContext context, value, AuthRepository? previous) {
            if (previous == null) {
              final dio = context.read<Dio>();
              final repository =
                  AuthRepository(dio: dio, baseUrl: 'http://$ip/auth');
              return repository;
            } else {
              return previous;
            }
          },
        ),
        ProxyProvider4<FlutterSecureStorage, UserMeRepository, AuthRepository,
            UserLoginStateProvider, UserMeProvider>(
          update: (BuildContext context, storage, userMeRepo, authRepo,
              loginStateProvider, UserMeProvider? previous) {
            if (previous == null) {
              return UserMeProvider(
                repository: userMeRepo,
                storage: storage,
                authRepository: authRepo,
                userLoginStateProvider: loginStateProvider,
              );
            } else {
              return previous;
            }
          },
        ),
        ChangeNotifierProxyProvider<UserLoginStateProvider, AuthProvider?>(
          create: (context) => null,
          update: (context, userLoginStateProvider, AuthProvider? previous) {
            if (previous == null) {
              Provider.of<UserMeProvider>(context, listen: false);
              return AuthProvider(
                userLoginStateProvider: userLoginStateProvider,
              );
            } else {
              return previous;
            }
          },
        ),
        ProxyProvider<AuthProvider, GoRouterProvider>(
          update: (BuildContext context, value, GoRouterProvider? previous) {
            if (previous == null) {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              return GoRouterProvider(
                provider: authProvider,
              );
            } else {
              return previous;
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final goRouter = context.watch<GoRouterProvider>().router;

          return MaterialApp.router(
            theme: ThemeData(
              fontFamily: 'NotoSans',
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
