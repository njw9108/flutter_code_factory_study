import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/dio/dio.dart';
import 'package:code_factory/common/view/splash_screen.dart';
import 'package:code_factory/product/provider/product_provider.dart';
import 'package:code_factory/product/repository/product_repository.dart';
import 'package:code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory/user/provider/auth_provider.dart';
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
            create: (_) => const FlutterSecureStorage()),
        ProxyProvider<FlutterSecureStorage, Dio>(
          update: (BuildContext context, storage, Dio? previous) {
            final dio = Dio();
            dio.interceptors.add(
              CustomInterceptor(storage: storage),
            );
            return dio;
          },
        ),
        ProxyProvider<Dio, RestaurantRepository>(
          update:
              (BuildContext context, value, RestaurantRepository? previous) {
            final dio = context.read<Dio>();
            final repository =
                RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
            return repository;
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
            final dio = context.read<Dio>();
            final repository =
                ProductRepository(dio, baseUrl: 'http://$ip/product');
            return repository;
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
            final dio = context.read<Dio>();
            final repository =
                UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
            return repository;
          },
        ),
        ProxyProvider<Dio, AuthRepository>(
          update: (BuildContext context, value, AuthRepository? previous) {
            final dio = context.read<Dio>();
            final repository =
                AuthRepository(dio: dio, baseUrl: 'http://$ip/user/me');
            return repository;
          },
        ),
        ChangeNotifierProvider<UserMeProvider>(
          create: (context) {
            final repository = context.read<UserMeRepository>();
            final storage = context.read<FlutterSecureStorage>();
            final authRepo = context.read<AuthRepository>();
            return UserMeProvider(
              repository: repository,
              storage: storage,
              authRepository: authRepo,
            );
          },
        ),
        ChangeNotifierProxyProvider<UserMeProvider, AuthProvider>(
          create: (context) => AuthProvider(
            userMeProvider: Provider.of<UserMeProvider>(context, listen: false),
          ),
          update: (context, userMeProvider, AuthProvider? previous) {
            return AuthProvider(userMeProvider: userMeProvider);
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
