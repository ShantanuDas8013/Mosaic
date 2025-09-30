import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/firebase_options.dart';
import 'package:mosaic/models/user_model.dart';
import 'package:mosaic/router.dart';
import 'package:mosaic/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  bool isLoading = false;

  void getData(WidgetRef ref, User data) async {
    isLoading = true;
    userModel =
        await ref
            .watch(authControllerProvider.notifier)
            .getUserData(data.uid)
            .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    isLoading = false;
    setState(() {}); // Trigger a rebuild after user data is loaded
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme state
    final isDarkMode = ref.watch(themeNotifierProvider);

    return ref
        .watch(authStateChangedProvider)
        .when(
          data:
              (data) => MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Mosaic',
                // Use theme based on current state
                theme:
                    isDarkMode
                        ? Pallete.darkModeAppTheme
                        : Pallete.lightModeAppTheme,
                routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) {
                    if (data != null) {
                      if (userModel == null && !isLoading) {
                        getData(ref, data);
                        return loggedOutRoute; // Show login screen while loading
                      }

                      if (userModel != null) {
                        return loggedInRoute; // Redirect to home screen when user data is loaded
                      }
                    }
                    return loggedOutRoute;
                  },
                ),
                routeInformationParser: const RoutemasterParser(),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
