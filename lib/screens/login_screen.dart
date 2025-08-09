import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_it/auth.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/sing_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool eyeOpened = true;
  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You signed in succefuly",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xFF447D9B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFD7D7D7),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Auth()),
        (route) => false,
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Error occure',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xFF447D9B),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFD7D7D7),
          )
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TapGestureRecognizer tap = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(
          context,
        ).pushReplacement(SlidePageRoute(page: SignUpScreen()));
      };
    return isLoading
        ? Scaffold(
            backgroundColor: Color(0xFF447D9B),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFD7D7D7)),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFF447D9B),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    child: Image.asset("images/login-3.png", fit: BoxFit.cover),
                  ),

                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD7D7D7),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Color(0xFFD7D7D7)),
                            controller: email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the field';
                              }
                              if (!value.contains('@gmail.com') ||
                                  value.contains(' ')) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD7D7D7),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFFE7743),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFFFE7743),
                                  width: 3,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFF273F4F),
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF273F4F),
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Color(0xFF273F4F),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          TextFormField(
                            style: TextStyle(color: Color(0xFFD7D7D7)),
                            controller: password,
                            obscureText: eyeOpened == true ? false : true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the field';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD7D7D7),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFFE7743),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFFFE7743),
                                  width: 3,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xFF273F4F),
                                  width: 2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF273F4F),
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Color(0xFF273F4F),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                              suffixIcon: eyeOpened == true
                                  ? TextButton(
                                      onPressed: () {
                                        setState(() {
                                          eyeOpened = !eyeOpened;
                                        });
                                      },
                                      style: ButtonStyle(
                                        iconColor: WidgetStateProperty.all(
                                          Color(0xFFD7D7D7),
                                        ),
                                        iconSize: WidgetStateProperty.all(25),
                                      ),
                                      child: Icon(Icons.visibility),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        setState(() {
                                          eyeOpened = !eyeOpened;
                                        });
                                      },
                                      style: ButtonStyle(
                                        iconColor: WidgetStateProperty.all(
                                          Color(0xFFD7D7D7),
                                        ),
                                        iconSize: WidgetStateProperty.all(25),
                                      ),
                                      child: Icon(Icons.visibility_off),
                                    ),
                            ),
                          ),

                          SizedBox(height: 30),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    signIn();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFE7743),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFFD7D7D7),
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Don't have an account? ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Cairo',
                                          color: Color(0xFFD7D7D7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "SingUp",
                                        style: TextStyle(
                                          color: Color(0xFFFE7743),
                                          fontSize: 20,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: tap,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
