import 'package:flutter/material.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/home_screen.dart';

class SplashReadyScreen extends StatefulWidget {
  const SplashReadyScreen({super.key});

  @override
  State<SplashReadyScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashReadyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(
        context,
      ).pushReplacement(SlidePageRoute(page: HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF447D9B), 
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logo.png',
                    width: 140,
                    height: 140,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "NoteIt",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo-Bold',
                      color: Color(0xFFD7D7D7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
