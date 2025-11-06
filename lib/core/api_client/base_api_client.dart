import 'package:dio/dio.dart';

abstract class BaseApiClient {
  Dio get dio;

  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}
