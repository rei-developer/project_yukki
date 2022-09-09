import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this.authType, [this.idToken]);

  final String authType;
  final String? idToken;

  static const clientId = '1066074368580-u7ashqcofh5sqti2l8m0e6914krgbhea.apps.googleusercontent.com';
  static const redirectUri = 'https://project-yukki.firebaseapp.com/__/auth/handler';

  Future<dynamic> signIn() async {
    switch (authType) {
      default:
        return _signInWithGoogle();
    }
  }

  Future<dynamic> _signInWithGoogle() async {
    final result = await DesktopWebviewAuth.signIn(GoogleSignInArgs(clientId: clientId, redirectUri: redirectUri));
    print('result?.idToken => ${result?.idToken}');
    print('result?.accessToken => ${result?.accessToken}');
    final credential = GoogleAuthProvider.credential(
      idToken: result?.idToken,
      accessToken: result?.accessToken,
    );
    print(FirebaseAuth.instance.currentUser?.uid);
    print(FirebaseAuth.instance.currentUser?.displayName);
    print(FirebaseAuth.instance.currentUser?.email);
    await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      return null;
    }
    print('idToken ==> $idToken');
  }
}
