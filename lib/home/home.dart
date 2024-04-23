import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/colors.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                context
                    .read<NoteDatabase>()
                    .addNote(textEditingController.text);

                Navigator.pop(context);
              }
            },
            child: Text(
              "Create",
              style: GoogleFonts.akatab(
                color: blueAccentColor,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNote(Note note) {
    textEditingController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Update note",
          style: GoogleFonts.akatab(
            color: blueAccentColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                context
                    .read<NoteDatabase>()
                    .updateNote(note.id, textEditingController.text);

                textEditingController.clear();
                Navigator.pop(context);
              }
            },
            child: Text(
              "Update",
              style: GoogleFonts.akatab(
                color: blueAccentColor,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notes",
          style: GoogleFonts.akatab(
            color: whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueAccentColor,
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          final note = currentNotes[index];
          return ListTile(
            title: Text(
              note.text,
              style: GoogleFonts.akatab(
                color: blueAccentColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => updateNote(note),
                  icon: Icon(
                    Icons.edit,
                    color: blueAccentColor,
                  ),
                ),
                IconButton(
                  onPressed: () => deleteNote(note.id),
                  icon: Icon(
                    Icons.delete,
                    color: blueAccentColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNote(),
        backgroundColor: blueAccentColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }
}
