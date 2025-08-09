import 'package:flutter/material.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/splash-1.jpg', fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacement(SlidePageRoute(page: LoginScreen()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 235, 124, 87),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Color(0xFFEEE3CB),
                  fontFamily: 'Cairo-Bold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
