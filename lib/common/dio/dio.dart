import 'package:code_factory/common/const/data.dart';
import 'package:code_factory/common/secure_storage/secure_storage.dart';
import 'package:code_factory/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  //1. 요청을 보낼때(요청을 보내기 직전)
  //요청이 보내질때마다 요청의 Header에 accessToken 값이 true면
  //authorization에 (storage에서 가져온)access token 값 넣어준다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] [${options.uri}]');
    //요청값 변경
    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('accessToken');

      //실제 토큰으로 대체
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('refreshToken');

      //실제 토큰으로 대체
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    //요청을 보냄
    return super.onRequest(options, handler);
  }

  //2. 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] [${response.requestOptions.uri}]');

    return super.onResponse(response, handler);
  }

  //3. 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401에러가 났을때(status code)
    //토큰 재발급 받는 시도를 하고 토큰이 재발급 되면
    //다시 새로운 토큰으로 요청을 한다.
    print('[ERROR] [${err.requestOptions.method}] [${err.requestOptions.uri}]');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //리프레쉬 토큰이 아예 없으면 에러를 던진다.
    if (refreshToken == null) {
      //에러를 발생시킨다. 항상 handler.reject를 사용한다(dio 문법)
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    //토큰을 발급 받으려다 에러가 난 경우
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    try {
      if (isStatus401 && !isPathRefresh) {
        final dio = Dio();
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        //새로운 토큰을 넣어줌
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        //토큰 변경
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송(토큰만 바꿔서)
        final response = await dio.fetch(options);

        //에러없이 요청을 끝낼수 있다.
        return handler.resolve(response);
      }
    } on DioError catch (e) {
      //로그아웃
      ref.read(authProvider.notifier).logout();

      //그대로 에러를 반환
      return handler.reject(e);
    }

    return handler.reject(err);
    //return super.onError(err, handler);
  }
}
