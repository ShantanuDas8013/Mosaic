import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:mosaic/core/constants/constants.dart";
import "package:mosaic/features/auth/controller/auth_controller.dart";

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({this.isFromLogin = true, super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(context, ref),
      icon: Image.asset(Constants.googlePath, width: 35),
      label: const Text(
        'Continue with Google',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
