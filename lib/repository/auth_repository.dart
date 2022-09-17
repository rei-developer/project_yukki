import 'package:dio/dio.dart';
import 'package:project_yukki/config/api_config.dart';
import 'package:project_yukki/services/api_service.dart';

class AuthRepository {
  AuthRepository(
    this.type,
    this.token,
  );

  final String type;
  final String token;

  Future<dynamic> verify() async => ApiService('$USER_ROUTE/verify').get(options: _options);

  Future<dynamic> create(String password) async => ApiService('$USER_ROUTE/add').post(
        options: _options,
        data: {
          'password': password,
        },
      );

  String get _authorization => '$type $token';

  Options get _options => Options(headers: {'authorization': _authorization});
}
