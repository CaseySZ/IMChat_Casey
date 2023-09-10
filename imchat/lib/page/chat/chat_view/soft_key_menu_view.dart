import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/api/emo_data.dart';
import 'package:imchat/page/chat/chat_view/audio_pick_view.dart';

import 'album_picker_view.dart';

class SoftKeyMenuView extends StatefulWidget {
  final double height;
  final bool isEmoji;
  final Function(List<Media>)? pictureCallback;
  final Function(String)? audioCallback;
  final Function(String)? emojiCallback;

  const SoftKeyMenuView({
    super.key,
    required this.height,
    this.isEmoji = false,
    this.pictureCallback,
    this.audioCallback,
    this.emojiCallback,
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
        padding: const EdgeInsets.only(left: 12),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            AlbumPickerView(
              callback: (imageArr) {
                if (widget.pictureCallback != null) {
                  widget.pictureCallback!(imageArr);
                }
              },
              child: _buildItem("相册", "assets/images/album_key.png"),
            ),
            AudioPickerView(
              callback: widget.audioCallback,
              child: _buildItem("语音", "assets/images/5S.png"),
            ),
          ],
        ),
      );
    }
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

  Widget _buildItem(String title, String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
