import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class ServerErrorException extends ApiException {
  ServerErrorException(super.errorMessage, super.errorCode);
}
