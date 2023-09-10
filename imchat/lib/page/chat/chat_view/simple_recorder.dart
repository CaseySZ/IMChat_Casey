import 'dart:async';
import 'dart:io';
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
import 'package:path_provider/path_provider.dart';
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
  String fileName = 'tau_file.mp4';
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  Timer? timer;

  String get audioRealPath {
    return "/sdcard/audioIM/$fileName";
  }

  @override
  void initState() {
    fileName = '${DateTime.now().millisecondsSinceEpoch}tau_file.mp4';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       statusInit();
    });
    super.initState();
  }

  void statusInit() async {
    bool isAgree = await Permission.storage.request().isGranted;
    if(!isAgree){
      showToast(msg: "请打开存储权限");
      await openAppSettings();
      return;
    }
    String saveDir = "/sdcard/audioIM";
    Directory root = Directory(saveDir);

    if (!root.existsSync()) {
      await root.create();
    }
    await openTheRecorder();
    _mRecorderIsInited = true;
    recordEvent();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerCount++;
      if (timerCount > 60) {
        timer.cancel();
        widget.callback?.call(audioRealPath, false);
      }
      setState(() {});
    });
    setState(() {});
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

  void recordEvent() async{
    await _mRecorder!
        .startRecorder(
      toFile: audioRealPath,
      codec: _codec,
      audioSource: theSource,
    );
  }

  Future stopRecorder() async {
    var url =  await _mRecorder!.stopRecorder();
    debugLog("finish recorder: $url");
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.callback?.call("", false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: ()  async{
                  timer?.cancel();
                  await stopRecorder();
                  if (timerCount < 2) {
                    showToast(msg: "语音时间太短, 发送已被取消");
                    widget.callback?.call("", false);
                  } else {

                    widget.callback?.call(audioRealPath, true);
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
                              const Icon(
                                Icons.mic_none_rounded,
                                size: 32,
                                color: Colors.white,
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
                    ),
                ),
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
                onTap: () async{
                  await stopRecorder();
                  timer?.cancel();
                  widget.callback?.call(audioRealPath, true);
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
      ),
    );
  }

  @override
  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }
}
