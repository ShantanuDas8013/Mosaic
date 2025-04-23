import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/features/auth/screens/login_screen.dart';
import 'package:mosaic/firebase_options.dart';
import 'package:mosaic/theme/pallete.dart';

void main() async {
  // Add this line to initialize the binding
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Pallete.darkModeAppTheme,
      home: const LoginScreen(), //Login Screen
    );
  }
}
