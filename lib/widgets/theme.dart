import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({
    Key? key,
    required this.setting,
    required this.firstText,
    required this.themeName,
  }) : super(key: key);
  final String firstText, themeName;
  final Map setting;
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  //STT setting
  bool _hasSpeech = false;
  final bool _logEvents = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  final SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
        finalTimeout: const Duration(milliseconds: 0));

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  //TTS setting
  FlutterTts flutterTts = FlutterTts();
  initTts() async {
    flutterTts.setLanguage('en-US'); // 언어 설정
    flutterTts.setPitch(1.0); // 음성 높낮이 설정
    flutterTts.setSpeechRate(1.0);
    //ios, macOS, Android onlu
    flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  Future<void> speak(textToSpeak) async {
    await flutterTts.speak(textToSpeak); // 텍스트 음성 변환 및 재생
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
    initTts();
    dialog.add({
      "role": "assistant",
      "content": widget.firstText,
    });
    firstText = widget.firstText;
    assistant = Text(dialog[0]["content"]);
    initGpt();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    stopListening();
  }

  late Widget assistant;
  List dialog = [];
  late String firstText;
  late List<OpenAIChatCompletionChoiceMessageModel> messages;

  //첫 인삿말 및 세팅 설정
  void initGpt() {
    String role = widget.setting["role"];
    String place = widget.setting["place"];
    String goal = widget.setting["goal"];
    String setting = """
    Let's say I am at $place and you are $role.
    Let's say I approach you, trying to $goal. Let's start a conversation. Speak one sentence at a time. You speak first.
    """;

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          setting,
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    final assistantMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          firstText,
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );
    messages = [
      systemMessage,
      assistantMessage,
    ];
  }

  @override
  Widget build(BuildContext context) {
    //대화 리스트 전달
    Future<String> sendPostRequest(prompt) async {
      OpenAI.apiKey = dotenv.env['apiKey'].toString();
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            prompt,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );
      messages.add(userMessage);
      dialog.add({
        "role": "user",
        "content": prompt,
      });
      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: messages,
        maxTokens: 200,
      );
      String response =
          chatCompletion.choices.first.message.content![0].text.toString();
      final responseMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            response,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );
      messages.add(responseMessage);
      dialog.add({
        "role": "assistant",
        "content": response,
      });
      speak(response);
      return response;
    }

    //마지막 전체 대화 정리
    void finalDialog() async {
      OpenAI.apiKey = dotenv.env['apiKey'].toString();

      final finalMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            """$dialog If the content doesn't sound like native speaker, change them to be more natural.
          """,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );
      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [finalMessage],
      );
      String response =
          chatCompletion.choices.first.message.content![0].text.toString();
      print("dialog $dialog");
      print(response);

      final db = FirebaseFirestore.instance;

      db
          .collection('users')
          .doc('user1')
          .collection('note')
          .doc(widget.themeName)
          .set({
        'content': response,
      }).onError((e, _) => print("Error writing document: $e"));
    }

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.contain,
        image: AssetImage('images/02.jpg'),
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: assistant,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Text(lastWords),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        onPressed: !_hasSpeech || speech.isListening
                            ? null
                            : startListening,
                        icon: const Icon(Icons.mic),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 0.0),
                          child: const Text("click!",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue)))
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      assistant = FutureBuilder<String>(
                        future: sendPostRequest(lastWords),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              '${snapshot.data}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            );
                          }
                        },
                      );
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
                IconButton(
                    onPressed: () {
                      finalDialog();
                    },
                    icon: const Icon(
                      Icons.done_outline_rounded,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //stt 설정
  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: 'en-US',
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    if (mounted) {
      setState(() {
        lastStatus = status;
      });
    }
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }
}
