import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Map notes = {};
  //ui 완성
  // notes 맵 각각 리스트뷰로 할당
  void _fromFirestore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users").doc("user1").collection("note").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          notes[docSnapshot.id] = data["content"];
          print(notes);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  List items = [
    '식당',
    '친구',
  ];

  @override
  void initState() {
    _fromFirestore();
    super.initState();
  }

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
