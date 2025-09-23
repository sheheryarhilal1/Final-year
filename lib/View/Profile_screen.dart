import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    return Scaffold(
      backgroundColor: Colors.black, // 👈 Screen background black
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3"), // Dummy profile image
            ),
            const SizedBox(height: 10),
            // Name
            const Text(
              "Michael Hic",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // Job title
            const Text(
              "Lead UI/UX Designer",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // Edit Profile Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {},
              child: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Options
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
