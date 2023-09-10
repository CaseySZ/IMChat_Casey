import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:imchat/page/chat/movie_play_page.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
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
  bool _mPlayerIsInited = false;
  String errorStr = "";

  bool get isVideoType {
    if (model?.contentType == 3 && errorStr.isEmpty && _mPlayerIsInited) {
      return true;
    }
    return false;
  }

  bool get isFile {
    if(model?.contentType == 3){
      if(model?.content?.contains(".zip") == true){
        return true;
      }
      if(model?.content?.contains(".rar") == true){
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if(!isFile) {
      initController();
    }
  }

  void initController() async {
    try {
      String url = model?.content ?? "";
      controller = VideoPlayerController.networkUrl(Uri.parse(url));
      if (model?.contentType == 3) {
        setState(() {});
      }
      await controller?.initialize();
      audioDuration = controller?.value.duration.inSeconds;
      _mPlayerIsInited = true;
    } catch (e) {
      _mPlayerIsInited = true;
      errorStr = e.toString();
      debugLog("audio error: $e");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(isFile){
          return;
        }
        if (isVideoType) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MoviePlayPage(controller: controller!);
          }));
          controller?.pause();
          return;
        }
        if (_mPlayerIsInited && errorStr.isEmpty) {
          if (isPlaying) {
            controller?.pause();
          } else {
            controller?.play();
          }
          isPlaying != isPlaying;
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (model?.contentType == 2) {
      return _buildAudioItem();
    } else if(isFile){
      return Image.asset("assets/images/zip.png", width: 74, height: 68,);
  } else {
      return _buildFileItem();
    }
  }

  Widget _buildFileItem() {
    double videoHeight = 120;
    if ((controller?.value.aspectRatio ?? 0) > 0) {
      videoHeight = 200 / controller!.value.aspectRatio;
    }
    return SizedBox(
      width: 200,
      height: videoHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (controller != null)
            SizedBox(
              width: 200,
              height: videoHeight,
              child: VideoPlayer(controller!),
            ),
          if (!_mPlayerIsInited)
            const LoadingCenterWidget(
              color: Color(0xff999999),
              radius: 14,
            ),
          if (isVideoType)
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/play.png",
                width: 60,
                height: 60,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAudioItem() {
    return SizedBox(
      height: 40,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (controller != null)
            SizedBox(
              width: 80,
              height: 30,
              child: VideoPlayer(controller!),
            ),
          Container(
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
                      if (!widget.isLeftStyle) ...[
                        if (!_mPlayerIsInited)
                          const CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 8,
                          ),
                        if (audioDuration != null)
                          Text(
                            "$audioDuration\"     ",
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                      ],
                      Transform.rotate(
                        //旋转90度
                        angle: widget.isLeftStyle ? 0 : pi,
                        child: const Icon(
                          Icons.volume_up,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.isLeftStyle) ...[
                        if (audioDuration != null)
                          Text(
                            "     $audioDuration\"",
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        if (!_mPlayerIsInited)
                          const CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 8,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            //  child:
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
