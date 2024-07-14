import 'package:vira_datry/model/note.dart';
import 'package:vira_datry/service/note_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = <Note>[];
  final NoteService _noteService = NoteService();

  List<Note> get getNotes {
    return _notes;
  }

  bool isLoading = false;

  Future<void> fetchNotes() async {
    try {
      isLoading = true;
      notifyListeners();
      isLoading = false;
      _notes = await _noteService.getAllNotes();
      notifyListeners();
    } catch (error) {
      print("Failed to fetch notes: $error");
    }
  }

  Future<bool> addNewNote(String title, String description) async {
    final note = Note(
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    try {
      final documentId = await _noteService.createNote(note);
      note.id = documentId; // Set ID dokumen dari Firestore
      _notes.add(note);
      notifyListeners();
      return true;
    } catch (error) {
      print("Failed to create note: $error");
      return false;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _noteService.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (error) {
      print("Failed to update note: $error");
    }
  }

  Future<void> removeNote(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _noteService.deleteNoteById(id);
      _notes.removeWhere((note) => note.id == id);
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Failed to delete note: $error");
    }
  }

  // Future<void> editNote(
  //     String id, String newTitle, String newDescription) async {
  //   final index = _notes.indexWhere((element) => element.id == id);

  //   if (index != -1) {
  //     _notes[index].title = newTitle;
  //     _notes[index].description = newDescription;
  //     _notes[index].createdAt =
  //         DateFormat.yMMMEd().format(DateTime.now()).toString();

  //     // await saveNotes();
  //     notifyListeners();
  //   }
  // }

  Future<void> saveNotes() async {
    // final prefs = await SharedPreferences.getInstance();
    // final notesJson = _notes.map((note) => note.toJson()).toList();
    // await prefs.setString('notes', json.encode(notesJson));
  }

  // Future<void> loadNotes() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final notesJson = prefs.getString('notes');
  //   if (notesJson != null) {
  //     final List<dynamic> notesList = json.decode(notesJson);
  //     _notes = notesList.map((json) => Note.fromJson(json)).toList();
  //     notifyListeners();
  //   }
  // }
}
