import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    required this.child,
    this.onPrimary,
    this.primary,
    this.borderRadius: 4.0,
    this.height: 50.0,
    this.onPressed,
  });

  final Widget child;
  final Color? onPrimary;
  final Color? primary;
  final double borderRadius;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          onPrimary: onPrimary,
          primary: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
