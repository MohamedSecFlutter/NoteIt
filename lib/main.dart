import 'package:flutter/material.dart';
import 'package:note_it/auth.dart';
import 'package:note_it/screens/add_screen.dart';
import 'package:note_it/screens/home_screen.dart';
import 'package:note_it/screens/login_screen.dart';
import 'package:note_it/screens/sing_up_screen.dart';
import 'package:note_it/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'auth',
      routes: {
        'splash': (context) => SplashScreen(),
        'login': (context) => LoginScreen(),
        'singup': (context) => SignUpScreen(),
        'home': (context) => HomeScreen(),
        'add': (context) => AddScreen(),
        'auth': (context) => Auth(),
      },
    );
  }
}
