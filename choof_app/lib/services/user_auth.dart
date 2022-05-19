import 'package:choof_app/controllers/landing_page_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class UserAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final userCredential =
              await _auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          return userCredential;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
          return userCredential;
        case LoginStatus.cancelled:
          return null;
        case LoginStatus.failed:
          return null;
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => TheAppleSignIn.isAvailable();

  /// Sign in with Apple
  Future signInWithApple() async {
    try {
      LandingPageController _controller = LandingPageController();
      late AuthorizationResult appleResult;
      if (GetStorage().read('appleCredential') == null) {
        appleResult = await TheAppleSignIn.performRequests([
          const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        _controller.storeAppleInformation(appleResult);
      } else {
        appleResult = GetStorage().read('appleCredential');
      }
      switch (appleResult.status) {
        case AuthorizationStatus.authorized:
          final AuthCredential credential =
              OAuthProvider('apple.com').credential(
            accessToken: String.fromCharCodes(
                appleResult.credential!.authorizationCode!),
            idToken:
                String.fromCharCodes(appleResult.credential!.identityToken!),
          );

          final userCredential = await _auth.signInWithCredential(credential);
          return userCredential;

        case AuthorizationStatus.error:
          print("Sign in failed: ${appleResult.error!.localizedDescription}");
          return null;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          return null;
      }
    } catch (error) {
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

  // get current user email
  getUserEmail() {
    final User user = _auth.currentUser!;
    final userEmail = user.email;
    return userEmail;
  }
}
