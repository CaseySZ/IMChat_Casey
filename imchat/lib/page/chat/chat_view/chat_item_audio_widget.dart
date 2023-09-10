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
  final bool isLeftStyle;

  const ChatItemAudioWidget({super.key, this.model, this.isLeftStyle = false});

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
    try {
      // String url = "https://pking.s3.ap-east-1.amazonaws.com/1700713437996388352.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230910T033219Z&X-Amz-SignedHeaders=host&X-Amz-Expires=900&X-Amz-Credential=AKIA4TG4XTMLKOHIWMNR%2F20230910%2Fap-east-1%2Fs3%2Faws4_request&X-Amz-Signature=aaa77c9f3d6255572533cdf77f7c2b9f3184a42a899ff61a5b40bd2c8b066aaa";
      //String url = "https://pking.s3.ap-east-1.amazonaws.com/1688137351215321088.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230910T034738Z&X-Amz-SignedHeaders=host&X-Amz-Expires=900&X-Amz-Credential=AKIA4TG4XTMLKOHIWMNR%2F20230910%2Fap-east-1%2Fs3%2Faws4_request&X-Amz-Signature=d583cd9dffc3155ef24ba6d233fdec2d04591f672efa265bafa15410f9d17155";
      String url = model?.content ?? "";
      controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller?.initialize();
      audioDuration = controller?.value.duration.inSeconds;
      _mPlayerIsInited = true;
      // _mPlayer.openPlayer().then((value) {
      //   _mPlayerIsInited = true;
      //   setState(() {});
      // });
    } catch (e) {
      debugLog("audio error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isPlaying) {
          controller?.pause();
          //flutterSound.thePlayer.stopPlayer();
        } else {
          controller?.play();

          // _mPlayer.startPlayer(
          //     fromURI: "https://pking.s3.ap-east-1.amazonaws.com/1700543833160421376.640293_216.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230909T161659Z&X-Amz-SignedHeaders=host&X-Amz-Expires=900&X-Amz-Credential=AKIA4TG4XTMLKOHIWMNR%2F20230909%2Fap-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7b3fa489048eaae5843e18612601f3cb4643cda5f02998844acabd60a4dee9cf", //model?.content,
          //     codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
          //     whenFinished: () {
          //       setState(() {});
          //     })
          //     .then((value) {
          //   setState(() {});
          // });
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
        decoration: BoxDecoration(
          color: widget.isLeftStyle ? const Color(0xffcccccc) : const Color(0xfff51b1b),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(8),
            bottomRight: const Radius.circular(8),
            topLeft: Radius.circular(widget.isLeftStyle ? 0 : 8),
            topRight: Radius.circular(widget.isLeftStyle ? 8 : 0),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: widget.isLeftStyle ? 0 : null,
              right: widget.isLeftStyle ? null : 0,
              child: Row(
                children: [
                  if (!widget.isLeftStyle && audioDuration != null)
                    Text(
                      "$audioDuration\"     ",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  Transform.rotate(
                    //旋转90度
                    angle: widget.isLeftStyle ? 0 : pi,
                    child: const Icon(
                      Icons.volume_up,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.isLeftStyle && audioDuration != null)
                    Text(
                      "     $audioDuration\"",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                ],
              ),
            ),
          ],
        ),
        //  child:
      ),
    );
  }
}
