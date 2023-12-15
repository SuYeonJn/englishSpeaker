import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'note_page.dart';
import '../widgets/buttons.dart';

class SpeakPage extends StatefulWidget {
  const SpeakPage(
      {super.key,
      required this.themeList,
      required this.greetingList,
      required this.settingList});

  final List themeList;
  final List greetingList;
  final List settingList;
  @override
  State<SpeakPage> createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> {
  Map notes = {};

  void _fromFirestore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users").doc("user1").collection("note").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          notes[docSnapshot.id] = data["content"];
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    _fromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < widget.themeList.length; i++)
              ThemeButton(
                  setting: widget.settingList[i],
                  firstText: widget.greetingList[i],
                  buttonName: widget.themeList[i]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(
                  notes: notes,
                ),
              ));
        },
        child: const Icon(Icons.note_sharp),
      ),
    );
  }
}
