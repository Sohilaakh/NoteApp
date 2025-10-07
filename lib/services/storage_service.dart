// lib/services/storage_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class StorageService {
  static final _supabase = Supabase.instance.client;


  static Future<String?> uploadProfileImage(File file) async {
    final uid = fb_auth.FirebaseAuth.instance.currentUser!.uid;
    final fileExt = p.extension(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
    final filePath = '$uid/$fileName';

    final storage = _supabase.storage.from('profiles');


    final result = await storage.upload(filePath, file,
        fileOptions: const FileOptions(upsert: true));
    if (result.isEmpty) return null;


    final publicUrl = storage.getPublicUrl(filePath);
    return publicUrl;
  }

}
