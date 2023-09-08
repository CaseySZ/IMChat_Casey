import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/images_animation.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

///
typedef _Fn = void Function();

/* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
 * But this permission is _is reserved for use by system components and is not available to third-party applications._
 * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
 *
 * I think that the problem is because it is illegal to record a communication in many countries.
 * Probably this stands also on iOS.
 * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
 *
 */
//const theSource = AudioSource.voiceUpLink;
//const theSource = AudioSource.voiceDownlink;

const theSource = AudioSource.microphone;

/// Example app.
class SimpleRecorder extends StatefulWidget {

  final Function(String, bool)? callback;
  const SimpleRecorder({super.key, this.callback});

  @override
  State<StatefulWidget> createState() {

    return _SimpleRecorderState();
  }
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  int timerCount = 0;

  String get timerDesc {
    int minInt = timerCount ~/ 60;
    int secInt = timerCount % 60;
    return "${minInt.toString().padLeft(2, "0")}:${secInt.toString().padLeft(2, "0")}";
  }

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  Timer? timer;
  @override
  void initState() {
    _mPath = '${DateTime.now().millisecondsSinceEpoch}tau_file.mp4';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      statusInit();
    });
    super.initState();
  }

  void statusInit() async {
    await openTheRecorder();
    _mRecorderIsInited = true;
    recordEvent();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerCount++;
      if(timerCount > 60){
        timer.cancel();
        widget.callback?.call(_mPath, false);
      }
      setState(() {});
    });
    setState(() {});
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void recordEvent() {
    _mRecorder!.startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    ).then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited && _mplaybackReady && _mRecorder!.isStopped && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? recordEvent : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: () async{
      widget.callback?.call("", false);
      return false;
    }, child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      appBar: BaseAppBar(
        titleWidget: ElevatedButton(
          onPressed: getPlaybackFn(),
          //color: Colors.white,
          //disabledColor: Colors.grey,
          child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
        ),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                stopRecorder();
                timer?.cancel();
                if(timerCount < 2){
                  showToast(msg: "语音时间太短, 发送已被取消");
                  widget.callback?.call("", false);
                }else {
                  widget.callback?.call(_mPath, true);
                }
              },
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xffb74124),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImagesAnimation(
                              w: 24,
                              h: 24,
                              entry: ImagesAnimationEntry(0, 2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "点此发送".localize,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 12),
            Text(
              timerDesc,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: (){
                stopRecorder();
                timer?.cancel();
                widget.callback?.call("", false);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFAF0E6),
                      Color(0xFFaaaaaa),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: Colors.black),
                ),
                child: const Text(
                  "取消录制",
                  style: TextStyle(color: Color(0xff666666), fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    ),);
  }

}


