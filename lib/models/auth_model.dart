class AuthModel {
  AuthModel(this.authType, this.idToken);

  factory AuthModel.initial({
    String? authType,
    String? idToken,
  }) =>
      AuthModel(
        authType ?? '',
        idToken ?? '',
      );

  AuthModel copyWith({
    String? authType,
    String? idToken,
  }) =>
      AuthModel(
        authType ?? this.authType,
        idToken ?? this.idToken,
      );

  final String authType;
  final String idToken;
}
