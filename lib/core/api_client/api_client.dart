import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_app/core/api_client/base_api_client.dart';
import 'package:injectable/injectable.dart';

import 'exceptions/bad_request_exception.dart';
import 'exceptions/connection_exception.dart';
import 'exceptions/invalid_data_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/server_error_exception.dart';
import 'exceptions/timeout_exception.dart';
import 'exceptions/unauthorized_exception.dart';
import 'exceptions/unknown_api_exception.dart';

@Injectable(as: BaseApiClient)
class ApiClient extends BaseApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      sendTimeout: Duration(seconds: 20),
      headers: {'accept': 'application/json'},
    );

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Dio get dio => _dio;
  @override
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    final response = _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return _handleResponse(response);
  }

  Future<T> _handleResponse<T>(Future<Response> response) async {
    try {
      final data = (await response).data;

      if (data is T) {
        return data;
      } else {
        throw InvalidDataException();
      }
    } on DioException catch (e) {
      _handleDioException(e);
    } on SocketException catch (e, _) {
      throw ConnectionException();
    } on InvalidDataException {
      rethrow;
    } on Exception catch (e, _) {
      rethrow;
    }
  }

  Never _handleDioException(DioException e) {
    final errorMessage = _processErrorMessage(e);
    final errorCode = _processErrorCode(e);
    const timeoutErrorMessage =
        'Request timed out. Please check your connection and try again.';

    switch (e.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
        throw TimeoutException(timeoutErrorMessage, errorCode);
      default:
        switch (e.response?.statusCode) {
          case 400:
            throw BadRequestException(errorMessage, errorCode);
          case 401:
          case 403:
            throw UnauthorizedException(errorMessage, errorCode);
          case 404:
          case 405:
            throw NotFoundException(errorMessage, errorCode);
          case 408:
            throw TimeoutException(errorMessage, errorCode);
          case 500:
          case 502:
          case 503:
            throw ServerErrorException(errorMessage, errorCode);
          default:
            throw UnknownApiException(
              errorMessage,
              errorCode,
              statusCode: e.response?.statusCode,
            );
        }
    }
  }

  String? _processErrorMessage(DioException e) {
    const errorMessageKey = 'message';
    const errorKey = 'error';

    final responseData = e.response?.data;

    if (responseData is Map<String, dynamic>) {
      final topLevelMessage = responseData[errorMessageKey];
      if (topLevelMessage is String) {
        return topLevelMessage;
      }

      final errorField = responseData[errorKey];
      if (errorField is Map<String, dynamic>) {
        final errorMessage = errorField[errorMessageKey];
        return errorMessage is String ? errorMessage : null;
      }
    }

    return null;
  }

  String? _processErrorCode(DioException e) {
    const errorCodeKey = 'codeName';
    const nameKey = 'name';
    const errorKey = 'error';

    final responseData = e.response?.data;

    if (responseData is Map<String, dynamic>) {
      final topLevelName = responseData[nameKey];
      if (topLevelName is String) {
        return topLevelName;
      }

      final topLevelCode = responseData[errorCodeKey];
      if (topLevelCode is String) return topLevelCode;
      final errorField = responseData[errorKey];
      if (errorField is Map<String, dynamic>) {
        final code = errorField[errorCodeKey];
        if (code is String) return code;

        final name = errorField[nameKey];
        if (name is String) return name;
      }
    }

    return null;
  }
}
