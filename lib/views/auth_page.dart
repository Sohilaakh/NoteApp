import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'notes_list.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthController authController = AuthController();
  bool isLogin = true;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isLogin)
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
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                if (isLogin) {
                  await authController.signIn(
                      email: emailCtrl.text.trim(),
                      password: passCtrl.text.trim());
                } else {
                  await authController.signUp(
                      email: emailCtrl.text.trim(),
                      password: passCtrl.text.trim(),
                      username: usernameCtrl.text.trim());
                }
                Get.offAll(() => NotesListPage());
              },
              child: Text(isLogin ? "Login" : "Sign Up",style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? "Don’t have an account? Sign Up"
                  : "Already have an account? Login", style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
