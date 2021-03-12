import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithFacebook();

  Future<User?> signInWithEmail(String email, String password);

  Future<User?> signUpWithEmail(String email, String password);

  Future<void> signOut();

  Stream<User?> authStateChanges();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleAuth = GoogleSignIn();
  final _facebookAuth = FacebookLogin();

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithGoogle() async {
    final account = await _googleAuth.signIn();
    final auth = await account?.authentication;
    final token = auth?.idToken;
    final accessToken = auth?.accessToken;
    if (token != null && accessToken != null) {
      final userCredential = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.credential(
        idToken: token,
        accessToken: accessToken,
      ));
      return userCredential.user;
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    final auth = await _facebookAuth.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (auth.status) {
      case FacebookLoginStatus.success:
        final accessToken = auth.accessToken!;
        await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        break;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: auth.error?.developerMessage,
        );
    }
  }

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }

  @override
  Future<User?> signUpWithEmail(String email, String password) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }

  @override
  Future<void> signOut() async {
    await _googleAuth.signOut();
    await _facebookAuth.logOut();
    await _firebaseAuth.signOut();
  }
}
