import 'package:flutter/material.dart';

import 'note_page.dart';
import 'buttons.dart';

class SpeakPage extends StatefulWidget {
  const SpeakPage({super.key});

  @override
  State<SpeakPage> createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> {
  var setting = [
    """Let's say I am at a McDonald's. 
      
      There are three types of menus: Cheeseburger, Bulgogi burger, shrimp burger.
      There are two types of toppings: tomato, lettuce.
      There are two types of side dishes: french fries, onion rings.
      There are two options: Eat here, take out.
      
      You are a staff at McDonald's who receives orders, and I am the customer. Let's say I approach you, trying to order a food. Let's start a conversation. Speak one sentence at a time. You speak first.""",
    """Let's say you are user's close friend.
     Let's say I approach you, and say hello to you. You are a friendly 21-year-old college student.  Let's start a conversation. Speak one sentence at a time. You speak first.""",
    """Let's say I am Hotel. 
      You are a staff at Hotel, and I am the customer. Let's say I approach you, trying to check in. Let's start a conversation. Speak one sentence at a time. You speak first."""
  ];
  List firstText = [
    "Welcome to McDonald's! How may I help you?",
    "Hi!",
    "Good Morning Sir. How may I help you?"
  ];

  List themeList = [
    "식당",
    "친구",
    "호텔 체크인/체크아웃",
    "비즈니스 미팅",
    "공항",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              ThemeButton(
                  setting: setting[i],
                  firstText: firstText[i],
                  buttonName: themeList[i]),
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
