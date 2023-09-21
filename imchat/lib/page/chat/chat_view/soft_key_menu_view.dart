import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/api/emo_data.dart';
import 'package:imchat/page/chat/chat_view/audio_pick_view.dart';
import 'package:imchat/page/red_packet/red_packet_page.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/utils/toast_util.dart';

import 'album_picker_view.dart';

class SoftKeyMenuView extends StatefulWidget {
  final double height;
  final bool isEmoji;
  final Function(List<Media>)? pictureCallback;
  final Function(Media)? videoCallback;
  final Function? collectCallback;
  final Function(String)? emojiCallback;

  const SoftKeyMenuView({
    super.key,
    required this.height,
    this.isEmoji = false,
    this.pictureCallback,
    this.collectCallback,
    this.emojiCallback,
    this.videoCallback,
  });

  @override
  State<StatefulWidget> createState() {
    return _SoftKeyMenuViewState();
  }
}

class _SoftKeyMenuViewState extends State<SoftKeyMenuView> {
  bool get isEmoji => widget.isEmoji;

  @override
  Widget build(BuildContext context) {
    if (isEmoji) {
      return SizedBox(
        height: widget.height,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Wrap(
              children: _buildEmojiItemList(),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: widget.height,
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            _bulidOneMenu(),
            const SizedBox(height: 24),
            _bulidTwoMenu(),
          ],
        )
      );
    }
  }


  Widget _bulidOneMenu() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AlbumPickerView(
          callback: (imageArr) {
            if(imageArr.isNotEmpty) {
              if (widget.pictureCallback != null) {
                widget.pictureCallback!(imageArr);
              }
            }
          },
          child: _buildItem("相册", "assets/images/album_key.png"),
        ),
        InkWell(
          onTap: (){
            widget.collectCallback?.call();
          },
          child: _buildItem("收藏", "assets/images/9p.png"),
        ),
        AlbumPickerView(
          isVideo: true,
          callback: (imageArr) {
            if(imageArr.isNotEmpty) {
              if (widget.videoCallback != null) {
                widget.videoCallback!(imageArr.first);
              }
            }
          },
          child: _buildItem("视频", "assets/images/album_icon.png"),
        ),
        AlbumPickerView(
          fctType: 1,
          callback: (imageArr) {
            if(imageArr.isNotEmpty) {
              if (widget.pictureCallback != null) {
                widget.pictureCallback!(imageArr);
              }
            }
          },
          child: _buildItem("拍照", "assets/images/8O.png"),
        ),
      ],
    );
  }

  Widget _bulidTwoMenu() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AlbumPickerView(
          isVideo: true,
          fctType: 1,
          callback: (imageArr) {
            if(imageArr.isNotEmpty) {
              if (widget.videoCallback != null) {
                widget.videoCallback!(imageArr.first);
              }
            }
          },
          child: _buildItem("拍视频", "assets/images/76.png"),
        ),

        InkWell(
          onTap: () {
            showToast(msg: "暂未开放");
           // Navigator.push(context, MaterialPageRoute(builder: (context){
           //   return  const RedPacketPage();
           // }));
          },
          child: _buildItem("红包", "assets/images/redpackge.jpeg"),
        ),
        InkWell(
          onTap: () {
            showToast(msg: "暂未开放");
          },
          child: _buildItem("语音聊天", "assets/images/5N.png"),
        ),
        InkWell(
          onTap: () {
            showToast(msg: "暂未开放");
          },
          child: _buildItem("视频聊天", "assets/images/6_.png"),
        ),
      ],
    );
  }

  List<Widget> _buildEmojiItemList() {
    List<Widget> itemArr = [];
    for (int i = 0; i < getEmojiList.length; i++) {
      itemArr.add(_buildEmojiItem(getEmojiList[i]));
    }
    return itemArr;
  }

  Widget _buildEmojiItem(Map<String, String> imageInfo) {
    String base64 = imageInfo["base64"] ?? "";
    return InkWell(
      onTap: () {
        widget.emojiCallback?.call(imageInfo["name"] ?? "");
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
        child: Image.memory(
          base64Decode(base64),
          width: 24,
          height: 24,
          gaplessPlayback: true, //防止重绘
        ),
      ),
    );
  }

  Widget _buildItem(String title, String imagePath,) {
    return SizedBox(
      width: screen.screenWidth/4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 35,
            height: 35,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff666262),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
