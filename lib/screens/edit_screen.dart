import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/home_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    super.key,
    required this.noteId,
    required this.iniTitle,
    required this.iniContent,
  });

  final String noteId;
  final String iniTitle;
  final String iniContent;
  @override
  State<EditScreen> createState() => _EditAddScreenState();
}

class _EditAddScreenState extends State<EditScreen> {

  bool isLoading = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  @override
  void initState() {
    super.initState();
    title.text = widget.iniTitle;
    content.text = widget.iniContent;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Color(0xFF447D9B),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFD7D7D7)),
            ),
          )
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
                child: Image.asset('images/edit.png'),
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
                      controller: title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the field';
                        }
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
                      controller: content,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the field';
                        }
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
                                      isLoading = true;
                                    });
                              try {
                                await FirebaseFirestore.instance
                                    .collection('note')
                                    .doc(widget.noteId)
                                    .update({
                                      'title': title.text,
                                      'content': content.text,
                                    });
                                Navigator.of(
                                  context,
                                ).pushAndRemoveUntil(SlidePageRoute(page: HomeScreen()),(route)=>false);
                              } catch (e) {}
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
                            "Save",
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
