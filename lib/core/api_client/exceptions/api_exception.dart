import 'package:equatable/equatable.dart';

class ApiException with EquatableMixin implements Exception {
  final String? errorMessage;
  final String? errorCode;

  ApiException(this.errorMessage, this.errorCode);

  @override
  List<Object?> get props => [errorMessage, errorCode];
}
