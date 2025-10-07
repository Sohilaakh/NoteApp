
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';

class SupabaseNoteService {
  static final _client = Supabase.instance.client;
  static const _table = 'notes';


  static Future<List<Note>> getNotes({required String userId}) async {
    final data = await _client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('id', ascending: false);


    final list = (data as List)
        .map((e) => Note.fromMap(e as Map<String, dynamic>))
        .toList();
    return list;
  }


  static Future<void> insert(Note note) async {
    await _client.from(_table).insert(note.toMap());
  }


  static Future<void> update(Note note) async {
    if (note.id == null) return; // avoid sending null to .eq()

    final updateMap = note.toMap()..remove('id'); // remove id from update payload
    await _client
        .from(_table)
        .update(updateMap)
        .eq('id', note.id!)
        .eq('user_id', note.userId);
  }


  static Future<void> delete({required int id, required String userId}) async {
    await _client.from(_table).delete().eq('id', id).eq('user_id', userId);
  }
}
