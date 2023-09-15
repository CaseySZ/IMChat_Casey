import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:video_player/video_player.dart';

import 'chat_view/chat_item_audio_widget.dart';

class MoviePlayPage extends StatefulWidget {
  final VideoPlayerController controller;

  const MoviePlayPage({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return _MoviePlayPageState();
  }
}

class _MoviePlayPageState extends State<MoviePlayPage> {
  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      statusInit();
    });
  }

  void statusInit() async {
    await controller.seekTo(Duration.zero);
    controller.play();
    isPlayingMedia = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: (){
          controller.play();
          isPlayingMedia = true;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio ,
                child: VideoPlayer(controller),
              ),
            ),
            if(controller.value.isBuffering)
              const LoadingCenterWidget(color: Color(0xff666666),),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: IconButton(
                  icon:  const Icon(
                    Icons.arrow_back_ios,
                    color:  Color(0xff1f1f1f),
                    shadows:  [
                      Shadow(
                        color: Colors.white,
                        offset:  Offset(1, 1),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
