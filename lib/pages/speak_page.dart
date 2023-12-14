import 'package:flutter/material.dart';

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
  // var settings = [
  //   """Let's say I am at a McDonald's.

  //     There are three types of menus: Cheeseburger, Bulgogi burger, shrimp burger.
  //     There are two types of toppings: tomato, lettuce.
  //     There are two types of side dishes: french fries, onion rings.
  //     There are two options: Eat here, take out.

  //     You are a staff at McDonald's who receives orders, and I am the customer. Let's say I approach you, trying to order a food. Let's start a conversation. Speak one sentence at a time. You speak first.""",
  //   """Let's say you are user's close friend.
  //    Let's say I approach you, and say hello to you. You are a friendly 21-year-old college student.  Let's start a conversation. Speak one sentence at a time. You speak first.""",
  //   """Let's say I am Hotel.
  //     You are a staff at Hotel, and I am the customer. Let's say I approach you, trying to check in. Let's start a conversation. Speak one sentence at a time. You speak first."""
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
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
                builder: (context) => const NotePage(),
              ));
        },
        child: const Icon(Icons.note_sharp),
      ),
    );
  }
}
