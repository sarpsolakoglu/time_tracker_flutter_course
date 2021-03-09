import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    required String text,
    Color? onPrimary,
    Color? primary,
    VoidCallback? onPressed,
  }) : super(
    child: Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
        ),
    ),
    onPrimary: onPrimary,
    primary: primary,
    onPressed: onPressed,
  );
}