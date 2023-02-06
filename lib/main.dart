import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/dio/dio.dart';
import 'package:code_factory/common/view/splash_screen.dart';
import 'package:code_factory/restaurant/repository/restaurant_repository.dart';
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
        Provider(create: (_) => const FlutterSecureStorage()),
        ProxyProvider<FlutterSecureStorage, Dio>(
          create: (_) => Dio(),
          update: (BuildContext context, storage, Dio? previous) {
            final dio = Dio();
            dio.interceptors.add(
              CustomInterceptor(storage: storage),
            );
            return dio;
          },
        ),
        ProxyProvider<Dio, RestaurantRepository>(
          create: (context) => RestaurantRepository(Dio()),
          update:
              (BuildContext context, value, RestaurantRepository? previous) {
            final dio = context.watch<Dio>();
            final repository =
                RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
            return repository;
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
