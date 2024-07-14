import 'package:vira_datry/model/note.dart';
import 'package:vira_datry/pages/components/primary_button.dart';
import 'package:vira_datry/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage({required this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  bool isLoading = false;
  late TextEditingController _descriptionController;
  late TextEditingController _titleController;
  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.note.description);
    _titleController = TextEditingController(text: widget.note.title);
  }

  handleSave() async {
    setState(() {
      isLoading = true;
    });
    Note newNote = Note(
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: DateTime.now(),
      id: widget.note.id,
    );
    await context
        .read<NoteProvider>()
        .updateNote(
          newNote,
        )
        .then(
      (value) {
        Navigator.pop(context);
      },
    ).onError(
      (error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "EDIT NOTE",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 16,
              letterSpacing: 2,
              wordSpacing: 2),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Title',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              controller: _titleController,
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Description',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
                controller: _descriptionController,
              ),
            ),
            PrimaryButton(
              height: 50,
              onPressed: handleSave,
              color: Colors.white,
              isLoading: isLoading,
              child: const Text(
                "SAVE NOTE",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
