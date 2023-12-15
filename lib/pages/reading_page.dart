import 'package:flutter/material.dart';
import '../widgets/lists.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  Map articles = {
    "Tech Crunch": "https://techcrunch.com/",
    "Economist": "https://www.economist.com/",
    "Korean Times": "https://www.koreatimes.co.kr/",
    "Business Insider": "https://www.businessinsider.com/"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News/Article'),
        ),
        body: ListWidget(source: articles));
  }
}
