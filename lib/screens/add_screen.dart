import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _EditAddScreenState();
}

class _EditAddScreenState extends State<AddScreen> {
   bool isDeleting = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Future<void> sendData() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    bool favorite = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) 
    {
      await FirebaseFirestore.instance.collection('note').add({
        'title': title,
        'content': content,
        'favorite': favorite,
        'uid': user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return isDeleting
        ? Scaffold(backgroundColor:Color(0xFF447D9B),body: Center(child: CircularProgressIndicator(color: Color(0xFFD7D7D7),)))
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(0xFFD7D7D7)),
              backgroundColor: Color(0xFF447D9B),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Add a new note ',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD7D7D7),
                      ),
                    ),
                    TextSpan(
                      text: 'Mohamed',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFE7743),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Color(0xFF447D9B),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 300,
                      child: Image.asset('images/add.png'),
                    ),

                    SizedBox(height: 20),

                    Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            maxLength: 25,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(color: Color(0xFFD7D7D7)),
                            controller: titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the field';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Color(0xFFD7D7D7)),
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontSize: 25,
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
                            maxLines: null,
                            keyboardType: TextInputType.multiline,

                            style: TextStyle(color: Color(0xFFD7D7D7)),
                            controller: contentController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the field';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Note',
                              labelStyle: TextStyle(
                                fontSize: 25,
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
                          SizedBox(height: 30),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      isDeleting = true;
                                    });
                                    await sendData();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      SlidePageRoute(page: HomeScreen()),
                                      (route) => false,
                                    );
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
                                  "Add",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFFD7D7D7),
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
