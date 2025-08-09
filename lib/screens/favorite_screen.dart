import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_it/screens/view_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    int count = widthDevice ~/ 200;
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF447D9B),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFD7D7D7)),
        backgroundColor: Color(0xFF447D9B),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Welcome ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD7D7D7),
                ),
              ),
              TextSpan(
                text: "Mohamed",
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('note')
            .where('favorite', isEqualTo: true)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No favorites available',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD7D7D7),
                ),
              ),
            );
          }
          final notes = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: EdgeInsets.all(10),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final title = note['title'];
              final content = note['content'];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 450),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ViewScreen(note: note),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            final offsetAnimation = Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: Text(
                            content,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
