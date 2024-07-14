import 'dart:convert';
import 'dart:developer';
import 'package:adimas_defatra/model/note.dart';
import 'package:http/http.dart' as http;

class NoteService {
  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/final-project-notes/databases/(default)/documents/notes";

  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['documents'];
      return data.map((doc) {
        final fields = doc['fields'];
        log(fields.toString());
        return Note(
          id: doc['name'].split('/').last, // Ambil ID dari URL dokumen
          title: fields['title']['stringValue'],
          description: fields['description']['stringValue'],
          createdAt: DateTime.parse(doc['updateTime']),
        );
      }).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<String> createNote(Note note) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fields': {
          'title': {'stringValue': note.title},
          'description': {'stringValue': note.description},
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final documentName = responseData['name'];
      final documentId = documentName.split('/').last;
      return documentId;
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<void> updateNote(Note note) async {
    final url = '$baseUrl/${note.id}';
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fields': {
          'title': {'stringValue': note.title},
          'description': {'stringValue': note.description},
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNoteById(String id) async {
    final url = '$baseUrl/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}
