import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class BadRequestException extends ApiException {
  BadRequestException(super.errorMessage, super.errorCode);
}
