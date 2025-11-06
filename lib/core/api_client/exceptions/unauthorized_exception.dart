import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.errorMessage, super.errorCode);
}
