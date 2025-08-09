import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePhoto extends StatefulWidget {
  const ChangePhoto({super.key});

  @override
  State<ChangePhoto> createState() => _ProfileImageSelectorState();
}

class _ProfileImageSelectorState extends State<ChangePhoto> {
  String selectedImage = 'images/profile-9.jpg';

  final List<String> profileImages = [
    'images/profile-1.jpg',
    'images/profile-2.jpg',
    'images/profile-3.jpg',
    'images/profile-4.jpg',
    'images/profile-5.jpg',
    'images/profile-6.jpg',
    'images/profile-7.jpg',
    'images/profile-8.jpg',
    'images/profile-9.jpg',
    'images/profile-10.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImage = prefs.getString('profileImage');
    if (savedImage != null) {
      setState(() {
        selectedImage = savedImage;
      });
    }
  }

  
  Future<void> _saveImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', imagePath);
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose photo"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: profileImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImage = profileImages[index];
                  });
                  _saveImage(profileImages[index]); 
                  Navigator.of(context).pop();
                },
                child: ClipOval(
                  child: Image.asset(
                    profileImages[index],
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _selectImage,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(selectedImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
