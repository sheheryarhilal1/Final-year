import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // ✅ Load saved image path
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString("profileImagePath");
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  // ✅ Pick image & save path
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      // Save path in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profileImagePath", file.path);

      setState(() {
        _image = file;
      });
    }
  }

  Widget buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage;

    if (_image != null) {
      profileImage = FileImage(_image!);
    } else {
      profileImage = const NetworkImage("https://i.pravatar.cc/150?img=3");
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ✅ Profile Picture
            CircleAvatar(radius: 40, backgroundImage: profileImage),
            const SizedBox(height: 10),

            // ✅ Show user name or email
            Text(
              user?.displayName ?? user?.email ?? "User",
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Lead UI/UX Designer",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // ✅ Edit Profile Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: _pickImage,
              child: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  buildListTile(Icons.person, "My Profile"),
                  buildListTile(Icons.lock, "Change Password"),
                  buildListTile(Icons.description, "Terms & Conditions"),
                  buildListTile(Icons.privacy_tip, "Privacy Policy"),
                  buildListTile(Icons.layers, "Change Layout"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
