import 'package:flutter/material.dart';
import 'package:note_it/models/slide_page_route.dart';
import 'package:note_it/screens/edit_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.note});
  final DocumentSnapshot note;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    final noteId = widget.note.id;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('note')
          .doc(noteId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFF447D9B),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final note = snapshot.data!;
        if (!note.exists) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).pop();
          });
          return SizedBox();
        }
        final data = note.data() as Map<String, dynamic>;
        final title = data['title'] ?? '';
        final content = data['content'] ?? '';
        final favorite = data['favorite'] ?? false;

        return Scaffold(
          backgroundColor: Color(0xFF447D9B),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xFFD7D7D7)),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFE7743),
              ),
            ),
            backgroundColor: Color(0xFF447D9B),
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('note')
                      .doc(note.id)
                      .update({'favorite': !favorite});
                  setState(() {});
                },
                icon: note['favorite']
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                color: Color(0xFFD7D7D7),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    SlidePageRoute(
                      page: EditScreen(
                        noteId: noteId,
                        iniTitle: title,
                        iniContent: content,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                color: Color(0xFFD7D7D7),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    isDeleting = true;
                  });
                  try {
                    await FirebaseFirestore.instance
                        .collection('note')
                        .doc(note.id)
                        .delete();
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Note deleted successfully')),
                    );
                  } catch (e) {
                    setState(() {
                      isDeleting = false;
                    });
                  }
                },
                icon: Icon(Icons.delete),
                color: Color(0xFFD7D7D7),
                iconSize: 30.0,
              ),
            ],
          ),
          body: isDeleting
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('images/view-1.png', width: 200),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              content,
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFFD7D7D7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
