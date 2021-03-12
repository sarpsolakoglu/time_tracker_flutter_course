import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'email_sign_in_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _showSignInError(BuildContext context, FirebaseAuthException exception) {
    if (exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed ',
      exception: exception,
    );
  }

  Future<void> _onSingInWithGooglePressed(BuildContext context) async {
    _setLoading(true);
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      await auth.signOut();
      _showSignInError(context, e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _onSingInWithFacebookPressed(BuildContext context) async {
    _setLoading(true);
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      await auth.signOut();
      _showSignInError(context, e);
    } finally {
      _setLoading(false);
    }
  }

  void _onSignInWithEmailPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailSignInPage(),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _onSignInAnonymouslyPressed(BuildContext context) async {
    _setLoading(true);
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      await auth.signOut();
      _showSignInError(context, e);
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign In With Google',
            assetName: 'images/google-logo.png',
            onPrimary: Colors.black87,
            primary: Colors.white,
            onPressed:
                _isLoading ? null : () => _onSingInWithGooglePressed(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign In With Facebook',
            assetName: 'images/facebook-logo.png',
            onPrimary: Colors.white,
            primary: Color(0xFF334D92),
            onPressed:
                _isLoading ? null : () => _onSingInWithFacebookPressed(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign In With Email',
            onPrimary: Colors.white,
            primary: Colors.teal[500],
            onPressed:
                _isLoading ? null : () => _onSignInWithEmailPressed(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go Anonymous',
            onPrimary: Colors.black87,
            primary: Colors.lime[300],
            onPressed:
                _isLoading ? null : () => _onSignInAnonymouslyPressed(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
