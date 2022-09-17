import 'package:dio/dio.dart';
import 'package:project_yukki/config/api_config.dart';
import 'package:project_yukki/i18n/strings.g.dart';

class ErrorHandler {
  ErrorHandler(this.error);

  final dynamic error;

  DioError handleDio() {
    String? errorMessage;
    final e = error as DioError;
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case TOO_MANY_REQUESTS_STATUS_CODE:
        errorMessage = t.api.errorMessage.tooManyRequest;
        break;
      case INTERNAL_SERVER_ERROR_STATUS_CODE:
        errorMessage = t.api.errorMessage.serverError;
        break;
      default:
        final i18n = t['api.errorMessage.${e.response}'];
        errorMessage = (i18n ?? e.response).toString();
        break;
    }
    print(errorMessage);
    // Fluttertoast.showToast(msg: errorMessage);
    throw e;
  }
}
