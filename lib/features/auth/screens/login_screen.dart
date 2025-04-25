import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:mosaic/core/common/loader.dart";
import "package:mosaic/core/common/sign_in_button.dart";
import "package:mosaic/core/constants/constants.dart";
import "package:mosaic/features/auth/controller/auth_controller.dart";

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset(Constants.logoPath, height: 40)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Loader()
              : Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Dive into Anything',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 0.5,
                    ),
                  ),
                  Image.asset(Constants.loginEmotePath, height: 400),
                  const SignInButton(),
                ],
              ),
    );
  }
}
