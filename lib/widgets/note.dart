import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Note extends StatefulWidget {
  const Note({super.key, required this.content});
  final String content;
  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    //List contents = json.decode(widget.content).toList();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.content)
            // for (int i = 0; i < contents.length; i++)
            //   Text("${contents[i]["role"]} : ${contents[i]["content"]}")
          ],
        ),
      ),
    );
  }
}
