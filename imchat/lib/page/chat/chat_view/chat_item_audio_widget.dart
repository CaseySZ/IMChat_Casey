import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:video_player/video_player.dart';

import '../model/chat_record_model.dart';

class ChatItemAudioWidget extends StatefulWidget {
  final ChatRecordModel? model;

  const ChatItemAudioWidget({super.key, this.model});

  @override
  State<StatefulWidget> createState() {
    return _ChatItemAudioWidgetState();
  }
}

class _ChatItemAudioWidgetState extends State<ChatItemAudioWidget> {
  ChatRecordModel? get model => widget.model;
  VideoPlayerController? controller;
  int? audioDuration;
  bool isPlaying = false;
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() async {
    _mPlayer.openPlayer().then((value) {
      _mPlayerIsInited = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(_mPlayerIsInited == false) return;
        if (isPlaying) {
          //flutterSound.thePlayer.stopPlayer();
        } else {
          _mPlayer.startPlayer(
              fromURI: model?.content,
              codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
              whenFinished: () {
                setState(() {});
              })
              .then((value) {
            setState(() {});
          });
        }
        isPlaying != isPlaying;
      },
      child: Container(
        height: 40,
        width: 120,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          color: Color(0xfff51b1b),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 0,
              child: Transform.rotate(
                //旋转90度
                angle: pi,
                child: const Icon(
                  Icons.volume_up,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        //  child:
      ),
    );
  }
}
