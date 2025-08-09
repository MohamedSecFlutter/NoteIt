import 'package:flutter/material.dart';
import 'package:note_it/models/change_photo.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/add_screen.dart';
import 'package:note_it/screens/favorite_screen.dart';
import 'package:note_it/screens/splash_screen.dart';
import 'package:note_it/screens/view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggingOut = false; // حالة تحميل تسجيل الخروج

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    String? username = user?.displayName;
    double widthDevice = MediaQuery.of(context).size.width;
    int count = widthDevice ~/ 200;
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xFF447D9B),
          appBar: AppBar(
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
                    text: "$username",
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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(SlidePageRoute(page: FavoriteScreen()));
                },
                icon: Icon(Icons.favorite),
                color: Color(0xFFD7D7D7),
              ),
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
                icon: Icon(Icons.person),
                color: Color(0xFFD7D7D7),
                iconSize: 30,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(SlidePageRoute(page: AddScreen()));
            },
            backgroundColor: Color(0xFFFE7743),
            child: Icon(Icons.add, color: Color(0xFFD7D7D7)),
          ),
          endDrawer: Drawer(
            backgroundColor: Color(0xFFD7D7D7),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ChangePhoto()],
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFFE7743),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '$username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Color(0xFF447D9B),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFFE7743),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '$email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Color(0xFF447D9B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Add Note',
                    style: TextStyle(
                      color: Color(0xFF447D9B),
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.create_outlined,
                    color: Color(0xFFFE7743),
                    size: 25,
                  ),
                  horizontalTitleGap: 5,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 450),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AddScreen(),
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
                ),
                ListTile(
                  title: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Color(0xFF447D9B),
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.favorite,
                    color: Color(0xFFFE7743),
                    size: 25,
                  ),
                  horizontalTitleGap: 5,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoriteScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFF447D9B),
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xFFFE7743),
                    size: 25,
                  ),
                  horizontalTitleGap: 5,
                  onTap: () async {
                    setState(() {
                      isLoggingOut = true;
                    });
                    try {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SplashScreen()));
                      await FirebaseAuth.instance.signOut();
                    } finally {
                      setState(() {
                        isLoggingOut = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('note')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: Color(0xFF447D9B),
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFFD7D7D7)),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No notes available',
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
        ),
        if (isLoggingOut)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFD7D7D7)),
            ),
          ),
      ],
    );
  }
}
