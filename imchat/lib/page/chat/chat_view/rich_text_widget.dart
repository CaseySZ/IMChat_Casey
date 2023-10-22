import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/emo_data.dart';

import '../model/chat_record_model.dart';

class RichTextWidget extends StatelessWidget {
  final ChatRecordModel? model;
  final bool isMe;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool? isReplyStyle;
  const RichTextWidget({super.key, this.model, this.isMe = true, this.isReplyStyle = false,this.textStyle,this.maxLines});


  String get contentDesc {
    if(isReplyStyle == true){
      //0文字，1图片，2语音，3文件，4红包，5转账，6消息回撤
      if(model?.contentType == 1){
        return "【图片】";
      }
      if(model?.contentType == 2){
        return "【语音】";
      }
      if(model?.contentType == 3){
        return "【文件】";
      }
      if(model?.contentType == 4){
        return "【红包】";
      }
      if(model?.contentType == 5){
        return "【转账】";
      }
    }
    return  model?.chatContent ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if(model?.richTitleArr == null){
      model?.parserChatTitle();
    }
    TextStyle style = const TextStyle(
      color: Color(0xff262424),
      fontSize: 14,
    );
    if (isMe) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }
    if(textStyle != null){
      style = textStyle!;
    }
    if(model?.contentType != 0 && isReplyStyle == true){
      return  Text(
        contentDesc,
        maxLines: maxLines,
        style: style,
      );
    }
    if (model?.richTitleArr?.isNotEmpty == true) {
      List<InlineSpan> textSpan = [];
      for (int i = 0; i < model!.richTitleArr!.length; i++) {
        RichTitle title = model!.richTitleArr![i];
        if (title.isImg && getEmojiMap[title.content] != null) {
          String base64 = getEmojiMap[title.content]!;
          textSpan.add(WidgetSpan(
            child: SizedBox(
              height: 16,
              width: 16,
              child: Image.memory(
                base64Decode(base64),
                gaplessPlayback: true, //防止重绘
              ),
            ),
          ));
        } else {
          textSpan.add(TextSpan(text: title.content));
        }
      }
      return Text.rich(
        TextSpan(
          style: style,
          children: textSpan,
        ),
        maxLines: maxLines,
      );
    } else {
      return Text(
        contentDesc,
        maxLines: maxLines,
        style: style,
      );
    }
  }

}
