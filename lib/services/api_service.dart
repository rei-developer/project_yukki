import 'package:dio/dio.dart';
import 'package:project_yukki/config/api_config.dart';
import 'package:project_yukki/handlers/error_handler.dart';

class ApiService {
  ApiService(this.path, [this.options]);

  final String path;
  final BaseOptions? options;

  Future<dynamic> get({
    Options? options,
    bool isOutside = false,
  }) async {
    try {
      return (await _api.get(
        getPath(isOutside),
        options: options,
      ))
          .data;
    } on DioError catch (e) {
      throw _errorHandler(e);
    }
  }

  Future<dynamic> post({
    Options? options,
    dynamic data,
    bool isOutside = false,
  }) async {
    try {
      return (await _api.post(
        getPath(isOutside),
        options: options,
        data: data,
      ))
          .data;
    } on DioError catch (e) {
      throw _errorHandler(e);
    }
  }

  String getPath(bool isOutside) => isOutside ? path : '$API_PATH/$path';

  DioError _errorHandler(e) => ErrorHandler(e).handleDio();

  Dio get _api => Dio(options);
}
