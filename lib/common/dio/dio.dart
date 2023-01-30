import 'package:code_factory/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  //1. 요청을 보낼때(요청을 보내기 직전)
  //요청이 보내질때마다 요청의 Header에 accessToken 값이 true면
  //authorization에 (storage에서 가져온)access token 값 넣어준다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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
    return super.onRequest(options, handler);
  }

  //2. 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  //3. 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }
}
