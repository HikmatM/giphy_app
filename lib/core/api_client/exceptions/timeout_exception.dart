import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class TimeoutException extends ApiException {
  TimeoutException(super.errorMessage, super.errorCode);
}
