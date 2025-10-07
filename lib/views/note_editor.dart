import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditorPage extends StatelessWidget {
  final NoteController controller = Get.find();
  final Note? note;

  NoteEditorPage({this.note});

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleCtrl.text = note!.title;
      contentCtrl.text = note!.content;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          note == null ? "New Note" : "Edit Note",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          if (note != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                controller.deleteNote(note!.id!);
                Get.back();
              },
            ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                style: const TextStyle(fontSize: 16),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Type something...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () async {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          final newNote = Note(
            id: note?.id,
            userId: uid,
            title: titleCtrl.text.trim(),
            content: contentCtrl.text.trim(),
            createdAt: note?.createdAt ?? DateTime.now(),
          );

          if (note == null) {
            await controller.addNote(newNote);
          } else {
            await controller.updateNote(newNote);
          }
          Get.back();
        },
      ),
    );
  }
}