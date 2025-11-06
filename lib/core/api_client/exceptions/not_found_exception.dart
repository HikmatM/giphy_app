import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException(super.errorMessage, super.errorCode);
}
