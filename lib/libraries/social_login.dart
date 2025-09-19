import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLogin {
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final scopes = [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName];

  Future<GoogleSignInAccount?> googleSignIn() async {
    try {
      final googleData = await _googleSignIn.signIn();
      return googleData;
    } catch (error) {
      if (kDebugMode) print('sign in error: $error');
      return null;
    }
  }

  Future<void> googleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (error) {
      if (kDebugMode) print('sign out error: $error');
    }
  }

  Future<AuthorizationCredentialAppleID?> appleSignIn() async {
    try {
      final appleData = await SignInWithApple.getAppleIDCredential(scopes: scopes);
      return appleData;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }
}
