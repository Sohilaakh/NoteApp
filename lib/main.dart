import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'views/notes_list.dart';
import 'views/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await supa.Supabase.initialize(
    url: 'https://vbzjfnimfnprhzlwfuhz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZiempmbmltZm5wcmh6bHdmdWh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0MTc0MjMsImV4cCI6MjA3Mjk5MzQyM30.5NA6gbV3z_TEGArt65eHNu33Yi_VnN5xAPDzLL5DWJY', // do NOT commit the service key!
  );
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: StreamBuilder<fb_auth.User?>(
        stream: fb_auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NotesListPage();
          } else {
            return AuthPage();
          }
        },
      ),

    );
  }
}
