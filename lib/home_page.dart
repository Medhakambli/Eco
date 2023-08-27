import 'package:animate_do/animate_do.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_app/openai_service.dart';
import 'package:voice_assistant_app/pallete.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  late String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: Text('Allen')),
        leading: Icon(Icons.menu),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
            print(lastWords);
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            String speech1 = 'hello medha';
            if (speech.contains('https')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
            }
            await systemSpeak(speech1);
            //print(speech);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening?Icons.stop
          :Icons.mic,
          color: Pallete.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Virtual Assitant Picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/virtualAssistant.png'))),
                  )
                ],
              ),
            ),
            FadeInRight(
              child: Visibility(
                //visible: generatedImageUrl!!=null,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      ),
                      border: Border.all(
                        color: Pallete.borderColor,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          // : generatedContent!,
                          :"Hello Medha",
                      style: TextStyle(fontSize: 20, fontFamily: 'Cera Pro'),
                    ),
                  ),
                ),
              ),
            ),
            // features list
            //if(generatedImageUrl!=null) Image.network(generatedImageUrl!),
            Visibility(
              //visible: generatedContent==null && generatedImageUrl==null,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10, left: 25),
                    child: Text(
                      'Here are few features',
                      style: TextStyle(
                          fontFamily: 'Cera Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: 'ChatGPT',
                    descriptionText:
                        'A smarter way to stay organised and informed with ChatGPT',
                  ),
                  FeatureBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headerText: 'Dall-E',
                    descriptionText:
                        'Get inspired and stay creative with your personal assistant powered by Dall-E',
                  ),
                  FeatureBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headerText: 'Smart Voice Assistant',
                    descriptionText:
                        'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
