import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:image_picker/image_picker.dart';

import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';
import 'auth_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = AuthController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  File? _selectedImage;
  String? _uploadedUrl;

  @override
  Widget build(BuildContext context) {
    final fb_auth.User? user = authController.currentUser;

    usernameCtrl.text = user?.displayName ?? "";
    emailCtrl.text = user?.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await authController.signOut();
              Get.offAll(() => AuthPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 70);
                  if (picked != null) {
                    setState(() => _selectedImage = File(picked.path));

                    // Upload to Supabase
                    final url =
                    await StorageService.uploadProfileImage(File(picked.path));
                    if (url != null) {
                      setState(() => _uploadedUrl = url);
                      await authController.updateProfile(photoUrl: url);
                      Get.snackbar("Success", "Profile image updated!");
                    } else {
                      Get.snackbar("Error", "Failed to upload image");
                    }
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_uploadedUrl != null
                      ? NetworkImage(_uploadedUrl!)
                      : (user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null)) as ImageProvider?,
                  child: (_selectedImage == null &&
                      _uploadedUrl == null &&
                      user?.photoURL == null)
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(hintText: "Username"),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: "New Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  await authController.updateProfile(
                    username: usernameCtrl.text.trim().isNotEmpty
                        ? usernameCtrl.text.trim()
                        : null,
                    email: emailCtrl.text.trim().isNotEmpty
                        ? emailCtrl.text.trim()
                        : null,
                    password: passCtrl.text.trim().isNotEmpty
                        ? passCtrl.text.trim()
                        : null,
                    photoUrl: _uploadedUrl,
                  );

                  Get.snackbar("Updated", "Profile updated successfully",
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: const Text("Update Profile", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
