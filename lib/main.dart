import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';


void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Voice(),
    );
  }
}

class Voice extends StatefulWidget {
  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {

  SpeechRecognition _speechRecognition;
  bool _isAvailable=false;
  bool _isListening=false;

  String resultText=" ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition=SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
        (bool result)=>setState(()=>_isAvailable=result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.blueGrey,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.cancel().then(
                          (result)=>setState((){
                            _isListening=result;
                            resultText="";
                          }
                      )
                      );
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.teal,
                  onPressed: (){
                    if(_isAvailable && !_isListening){
                      _speechRecognition
                        .listen(locale: "en_US")
                        .then((result)=>print('$result'));}
                  },

                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.black54,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.stop().then(
                        (result)=>setState(()=>_isListening=result),
                      );
                 } },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,

              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

