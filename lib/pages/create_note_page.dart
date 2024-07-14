import 'dart:developer';

import 'package:vira_datry/model/note.dart';
import 'package:vira_datry/pages/components/primary_button.dart';
import 'package:vira_datry/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateNotePage extends StatefulWidget {
  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  // late String titleText;
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  bool isLoading = false;

  handleSave() async {
    log("COK");
    setState(() {
      isLoading = true;
    });
    await context
        .read<NoteProvider>()
        .addNewNote(
          titleController.text,
          descriptionController.text,
        )
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: "Something went wrong!");
        }
      },
    ).onError(
      (error, stackTrace) {
        Fluttertoast.showToast(msg: "Something went wrong!");
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    titleController.clear();
    descriptionController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "CREATE NOTE",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 16,
              wordSpacing: 2,
              letterSpacing: 2),
        ),
        iconTheme: IconThemeData(color: Colors.black54),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              controller: titleController,
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
                controller: descriptionController,
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
