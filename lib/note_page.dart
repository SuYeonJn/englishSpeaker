import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List items = [
    '식당',
    '친구',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(items[index]),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
