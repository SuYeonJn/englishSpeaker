import 'package:flutter/material.dart';

import 'widgets/buttons.dart';
import 'pages/speak_page.dart';
import 'pages/audio_page.dart';
import 'pages/shorts_page.dart';
import 'pages/reading_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List themeList = [];
  List greetingList = [];
  List settingList = [];
  //themeList initialize problem
  void _fromFirestore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List names = [];
    List greetings = [];
    List settings = [];

    db.collection("settings").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          names.add(data["name"]);
          greetings.add(data["firstText"]);
          settings.add(data["setting"]);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      themeList = names;
      greetingList = greetings;
      settingList = settings;
    });
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
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const MainButton(
                  buttonName: "Shorts",
                  page: ShortsPage(),
                ),
                MainButton(
                  buttonName: "Speak",
                  page: SpeakPage(
                    themeList: themeList,
                    greetingList: greetingList,
                    settingList: settingList,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainButton(
                  buttonName: "Audio",
                  page: AudioPage(),
                ),
                MainButton(
                  buttonName: "News/Article",
                  page: ReadingPage(),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
