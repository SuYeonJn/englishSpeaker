import 'package:flutter/material.dart';

import 'widgets/buttons.dart';
import 'speak_page.dart';
import 'note_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainButton(
                  buttonName: "Shorts",
                  page: SpeakPage(),
                ),
                MainButton(
                  buttonName: "Speak",
                  page: SpeakPage(),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainButton(
                  buttonName: "Audio",
                  page: SpeakPage(),
                ),
                MainButton(
                  buttonName: "Note",
                  page: NotePage(),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
