import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/validate/validate_bloc.dart';
import 'package:hackathon/src/bloc/validate/validate_event.dart';
import 'package:hackathon/src/bloc/validate/validate_state.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

const int SAMPLE_RATE = 8000;
const int BLOCK_SIZE = 4096;

enum Media {
  file,
  asset,
  remoteExampleFile,
}
enum AudioState {
  isPlaying,
  isPaused,
  isStopped,
  isRecording,
  isRecordingPaused,
}

final exampleAudioFilePathMP3 =
    "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3";
final exampleAudioFilePathOPUS =
    "https://whatsapp-inbox-server.clare.ai/api/file/showFile?fileName=data/audios/e3f16eb2-10c3-45c9-b0fa-900c94cbe805.opus&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxMWI5YjQ3Zi1jMzBjLTRlZDMtYTFhNy1iNmYxNzRkMWQ1NTYiLCJ1bmlxdWVfbmFtZSI6InZlcm5hbEBjbGFyZS5haSIsIm5hbWVpZCI6InZlcm5hbEBjbGFyZS5haSIsImVtYWlsIjoidmVybmFsQGNsYXJlLmFpIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiRVhURVJOQUxfQURNSU5JU1RSQVRPUiIsImV4cCI6MjUzNDAyMzAwODAwLCJpc3MiOiJDbGFyZV9BSSIsImF1ZCI6IkNsYXJlX0FJIn0.yXVZ3n_lYYvJ1rGyF2mVh-80HuS0EEp7sQepxn9rGcY";
final albumArtPath =
    "https://file-examples-com.github.io/uploads/2017/10/file_example_PNG_500kB.png";

class ValidateScreen extends StatefulWidget {
  @override
  _ValidateScreenState createState() => _ValidateScreenState();
}

class _ValidateScreenState extends State<ValidateScreen> {
  final _validateBloc = ValidateBloc();
  final _prefs = locator<Preference>();
  List<String> _path = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];
  StreamSubscription _playerSubscription;

  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  String _playerTxt = '00:00:00';

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  Media _media = Media.file;
  Codec _codec = Codec.pcm16WAV;
  bool _decoderSupported = true; // Optimist
  String voicepath;

  // Whether the user wants to use the audio player features
  bool _isAudioPlayer = false;

  double _duration = null;
  StreamController<Food> recordingDataController;
  IOSink sink;

  Future<void> _initializeExample(bool withUI) async {
    await playerModule.closeAudioSession();
    _isAudioPlayer = withUI;
    await playerModule.openAudioSession(
        withUI: withUI,
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
    initializeDateFormatting();
    await setCodec(_codec);
  }

  Future<void> init() async {
    await _initializeExample(false);
    if (Platform.isAndroid) {
      await copyAssets();
    }
  }

  Future<void> copyAssets() async {
    Uint8List dataBuffer =
        (await rootBundle.load("assets/canardo.png")).buffer.asUint8List();
    String path = await playerModule.getResourcePath() + "/assets";
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    await File(path + '/canardo.png').writeAsBytes(dataBuffer);
  }

  @override
  void initState() {
    _validateBloc.add(InitialValidateEvent());
    super.initState();
    init();
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelPlayerSubscriptions();
    releaseFlauto();
  }

  Future<void> releaseFlauto() async {
    try {
      await playerModule.closeAudioSession();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  Future<void> getDuration() async {
    switch (_media) {
      case Media.file:
      case Media.remoteExampleFile:
        _duration = null;
        break;
    }
    setState(() {});
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  // In this simple example, we just load a file in memory.This is stupid but just for demonstration  of startPlayerFromBuffer()
  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      print('The file is ${contents.length} bytes long.');
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<String> assetSample = [
    'assets/samples/sample.aac',
    'assets/samples/sample.aac',
    'assets/samples/sample.opus',
    'assets/samples/sample_opus.caf',
    'assets/samples/sample.mp3',
    'assets/samples/sample.ogg',
    'assets/samples/sample.pcm',
    'assets/samples/sample.wav',
    'assets/samples/sample.aiff',
    'assets/samples/sample_pcm.caf',
    'assets/samples/sample.flac',
    'assets/samples/sample.mp4',
    'assets/samples/sample.amr', // amrNB
    'assets/samples/sample.amr', // amrWB
  ];

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress.listen((e) {
      if (e != null) {
        maxDuration = e.duration.inMilliseconds.toDouble();
        if (maxDuration <= 0) maxDuration = 0.0;

        sliderCurrentPosition =
            min(e.position.inMilliseconds.toDouble(), maxDuration);
        if (sliderCurrentPosition < 0.0) {
          sliderCurrentPosition = 0.0;
        }

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.position.inMilliseconds,
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        this.setState(() {
          this._playerTxt = txt.substring(0, 8);
        });
      }
    });
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    });
    return bytes;
  }

  Future<void> feedHim(String path) async {
    Uint8List data = await _readFileByte(path);
    return playerModule.feedFromStream(data);
  }

  Future<void> startPlayer() async {
    try {
      String audioFilePath;
      Codec codec = _codec;
      if (_media == Media.file) {
//          audioFilePath = localFilePath;
        audioFilePath = voicepath;
        print(audioFilePath);
      }
      if (audioFilePath != null) {
        await playerModule.startPlayer(
            fromURI: audioFilePath,
            codec: codec,
            sampleRate: SAMPLE_RATE,
            whenFinished: () {
              print('Play finished');
              setState(() {});
            });
      }
      _addListeners();
      setState(() {});
      print('<--- startPlayer');
    } catch (err) {
      print('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('stopPlayer');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {
      print('error: $err');
    }
    this.setState(() {});
  }

  void pauseResumePlayer() async {
    if (playerModule.isPlaying) {
      await playerModule.pausePlayer();
    } else {
      await playerModule.resumePlayer();
    }
    setState(() {});
  }

  void seekToPlayer(int milliSecs) async {
    print('-->seekToPlayer');
    if (playerModule.isPlaying)
      await playerModule.seekToPlayer(Duration(milliseconds: milliSecs));
    print('<--seekToPlayer');
  }

  void Function() onPauseResumePlayerPressed() {
    if (playerModule == null) return null;
    if (playerModule.isPaused || playerModule.isPlaying) {
      return pauseResumePlayer;
    }
    return null;
  }

  void Function() onStopPlayerPressed() {
    if (playerModule == null) return null;
    return (playerModule.isPlaying || playerModule.isPaused)
        ? stopPlayer
        : null;
  }

  void Function() onStartPlayerPressed() {
    if (playerModule == null) return null;
    if (_media == Media.file) {
      return (playerModule.isStopped) ? startPlayer : null;
    }

    // Disable the button if the selected codec is not supported
//    if (!(_decoderSupported || _codec == Codec.pcm16))
//      return null;

    return (playerModule.isStopped) ? startPlayer : null;
  }

  void setCodec(Codec codec) async {
    _decoderSupported = await playerModule.isDecoderSupported(codec);

    setState(() {
      _codec = codec;
    });
  }

//  void Function(bool) audioPlayerSwitchChanged() {
//    if (!playerModule.isStopped) return null;
//    return ((newVal) async {
//      try {
//        await _initializeExample(newVal);
//        setState(() {});
//      } catch (err) {
//        print(err);
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final playerControls = Row(
      children: <Widget>[
        Container(
          width: 56.0,
          height: 56.0,
          child: ClipOval(
            child: FlatButton(
              onPressed: onStartPlayerPressed(),
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(onStartPlayerPressed() != null
                    ? 'res/icons/ic_play.png'
                    : 'res/icons/ic_play_disabled.png'),
              ),
            ),
          ),
        ),
        Container(
          width: 56.0,
          height: 56.0,
          child: ClipOval(
            child: FlatButton(
              onPressed: onPauseResumePlayerPressed(),
              padding: EdgeInsets.all(8.0),
              child: Image(
                width: 36.0,
                height: 36.0,
                image: AssetImage(onPauseResumePlayerPressed() != null
                    ? 'res/icons/ic_pause.png'
                    : 'res/icons/ic_pause_disabled.png'),
              ),
            ),
          ),
        ),
        Container(
          width: 56.0,
          height: 56.0,
          child: ClipOval(
            child: FlatButton(
              onPressed: onStopPlayerPressed(),
              padding: EdgeInsets.all(8.0),
              child: Image(
                width: 28.0,
                height: 28.0,
                image: AssetImage(onStopPlayerPressed() != null
                    ? 'res/icons/ic_stop.png'
                    : 'res/icons/ic_stop_disabled.png'),
              ),
            ),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
    final playerSlider = Container(
        height: 56.0,
        child: Slider(
            value: min(sliderCurrentPosition, maxDuration),
            min: 0.0,
            max: maxDuration,
            onChanged: (double value) async {
              await seekToPlayer(value.toInt());
            },
            divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt()));

    Widget playerSection = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
          child: Text(
            this._playerTxt,
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onStartPlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(onStartPlayerPressed() != null
                        ? 'res/icons/ic_play.png'
                        : 'res/icons/ic_play_disabled.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onPauseResumePlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    width: 36.0,
                    height: 36.0,
                    image: AssetImage(onPauseResumePlayerPressed() != null
                        ? 'res/icons/ic_pause.png'
                        : 'res/icons/ic_pause_disabled.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onStopPlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    width: 28.0,
                    height: 28.0,
                    image: AssetImage(onStopPlayerPressed() != null
                        ? 'res/icons/ic_stop.png'
                        : 'res/icons/ic_stop_disabled.png'),
                  ),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        Container(
            height: 30.0,
            child: Slider(
                value: min(sliderCurrentPosition, maxDuration),
                min: 0.0,
                max: maxDuration,
                onChanged: (double value) async {
                  await seekToPlayer(value.toInt());
                },
                divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt())),
        Container(
          height: 30.0,
          child: Text(_duration != null ? "Duration: $_duration sec." : ''),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: BlocListener<ValidateBloc, ValidateState>(
          cubit: _validateBloc,
          listener: (context, state) {
            if (state.isDone) {
              Navigator.of(context).pushReplacementNamed('/finish', arguments: (Route<dynamic> route) => false);
            }
            if (state.isNext != null) {
              if (state.isNext) {
                switch (_prefs.getGameList()[0]) {
                  case 0:
                    Navigator.of(context).pushReplacementNamed('/speech',
                        arguments: (Route<dynamic> route) => false);
                    break;
                  case 1:
                    Navigator.of(context).pushReplacementNamed('/text',
                        arguments: (Route<dynamic> route) => false);
                    break;
                  case 2:
                    Navigator.of(context).pushReplacementNamed('/validate',
                        arguments: (Route<dynamic> route) => false);
                    break;
                }
              }
            }
          },
          child: BlocBuilder<ValidateBloc, ValidateState>(
            cubit: _validateBloc,
            builder: (context, state) {
              if (!state.isLoading) {
                if (state.errorMessage == null) {
                  voicepath = state.localVoicePath;
                  print(state.voiceList.toString());
                  return ListView(
                      children: <Widget>[
                        playerSection,
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.1),
                            child: Text(
                              state.voiceList[0]["text_label"],
                              style: TextStyle(fontSize: 22),
                            )),
                        SizedBox(height: deviceHeight * 0.07),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _validateBloc.add(SubmitEvent(
                                      validation: true, context: context));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    textStyle: TextStyle()),
                                child: Container(
                                    height: deviceHeight * 0.06,
                                    width: deviceWidth * 0.37,
                                    alignment: AlignmentDirectional.center,
                                    child: Text("Correct")),
                              ),
                              SizedBox(width: deviceWidth * 0.06),
                              ElevatedButton(
                                onPressed: () {
                                  _validateBloc.add(SubmitEvent(
                                      validation: false, context: context));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    textStyle: TextStyle()),
                                child: Container(
                                    height: deviceHeight * 0.06,
                                    width: deviceWidth * 0.37,
                                    alignment: AlignmentDirectional.center,
                                    child: Text("Wrong")),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                          child: ElevatedButton(
                            onPressed: () {
                              _validateBloc.add(SkipEvent());
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                textStyle: TextStyle()),
                            child: Text("Skip"),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.1),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "SCORE :",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: StepProgressIndicator(
                              totalSteps: _prefs.getGameMax(),
                              currentStep: _prefs.getGameScore(),
                              size: 12,
                              padding: 0.25,
                              selectedGradientColor: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.yellowAccent, Colors.deepOrange],
                              ),
                            ),
                          ),
                        )
                        // ignore: missing_return
                      ]);
                } else {
                  if (state.errorMessage == "Request timeout") {
                    return ListView(shrinkWrap: true, children: [
                      Center(
                        child: Text(
                          "Request Timeout",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: deviceHeight*0.05),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _validateBloc.add(SkipEvent());
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle()),
                          child: Text("Skip"),
                        ),
                      ),
                    ]);
                  } else {
                    return Text(state.errorMessage);
                  }
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
