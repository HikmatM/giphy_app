import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class UnknownApiException extends ApiException {
  final int? statusCode;

  UnknownApiException(super.errorMessage, super.errorCode, {this.statusCode});
}
