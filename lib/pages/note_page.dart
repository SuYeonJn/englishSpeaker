import 'package:flutter/material.dart';
import '../widgets/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.notes});
  final Map notes;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    List themesList = widget.notes.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: themesList.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(themesList[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Note(
                              content: widget.notes[themesList[index]],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
