import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/auth_config.dart';
import 'package:project_yukki/models/auth_model.dart';

class AuthProvider extends StateNotifier<AuthModel> {
  AuthProvider(this.ref) : super(AuthModel.initial());

  final Ref ref;

  Future<dynamic> signIn(String authType) async {
    setAuthType(authType);
    switch (authType) {
      default:
        await _signInWithGoogle();
        break;
    }
  }

  void setAuthType(String authType) => state = state.copyWith(authType: authType);

  void setIdToken(String idToken) => state = state.copyWith(idToken: idToken);

  void clear() => state = AuthModel.initial();

  Future<dynamic> _signInWithGoogle() async {
    final result = await DesktopWebviewAuth.signIn(GoogleSignInArgs(clientId: clientId, redirectUri: redirectUri));
    final credential = GoogleAuthProvider.credential(
      idToken: result?.idToken,
      accessToken: result?.accessToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      return null;
    }
    setIdToken(idToken);
    print(idToken);
  }
}

final authProvider = StateNotifierProvider<AuthProvider, AuthModel>((ref) => AuthProvider(ref));
