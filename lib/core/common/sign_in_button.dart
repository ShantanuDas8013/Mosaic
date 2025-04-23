import "package:flutter/material.dart";
import "package:mosaic/core/constants/constants.dart";

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(Constants.googlePath, width: 35),
      label: const Text(
        'Continue with Google',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
