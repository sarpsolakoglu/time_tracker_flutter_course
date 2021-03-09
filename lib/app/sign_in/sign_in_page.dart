import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign In With Google',
            assetName: 'images/google-logo.png',
            onPrimary: Colors.black87,
            primary: Colors.white,
            onPressed: _onSingInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign In With Facebook',
            assetName: 'images/facebook-logo.png',
            onPrimary: Colors.white,
            primary: Color(0xFF334D92),
            onPressed: _onSingInWithFacebook,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign In With Email',
            onPrimary: Colors.white,
            primary: Colors.teal[500],
            onPressed: _onSignInWithEmail,
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
            onPressed: _onSignInAnonymously,
          ),
        ],
      ),
    );
  }

  void _onSingInWithGoogle() {
    print('Sign In With Google');
  }

  void _onSingInWithFacebook() {
    print('Sign In With Facebook');
  }

  void _onSignInWithEmail() {
    print('Sign In With Email');
  }

  void _onSignInAnonymously() {
    print('Sign In Anonymously');
  }
}
