import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String text,
    required String assetName,
    Color? onPrimary,
    Color? primary,
    VoidCallback? onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          onPrimary: onPrimary,
          primary: primary,
          onPressed: onPressed,
        );
}
