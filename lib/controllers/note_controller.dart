
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/note.dart';
import '../services/supabase_note_service.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  String get userId => fb_auth.FirebaseAuth.instance.currentUser!.uid;

  Future<void> fetchNotes() async {
    notes.value = await SupabaseNoteService.getNotes(userId: userId);
  }

  Future<void> addNote(Note note) async {
    await SupabaseNoteService.insert(note);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await SupabaseNoteService.update(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await SupabaseNoteService.delete(id: id, userId: userId);
    await fetchNotes();
  }
}
