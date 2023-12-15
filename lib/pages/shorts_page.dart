import 'package:flutter/material.dart';
import '../widgets/lists.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  Map videos = {
    "1.5 HOUR English Conversation Lesson":
        "https://www.youtube.com/watch?v=lhFU5H5KPFE",
    "English Imitation Lesson": "https://www.youtube.com/watch?v=FfhZFRvmaVY",
    "Understand Native English Speakers with this Advanced Listening Lesson":
        "https://www.youtube.com/watch?v=D6_qpaSxAQc",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video'),
        ),
        body: ListWidget(
          source: videos,
        ));
  }
}
