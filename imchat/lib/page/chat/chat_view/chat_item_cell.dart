import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/alert/long_press_menu.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/utils/screen.dart';

import '../../../api/im_api.dart';
import '../../../tool/image/custom_new_image.dart';
import '../model/chat_record_model.dart';

class ChatItemCell extends StatefulWidget {
  final ChatRecordModel? model;
  final Function(double, double)? callback;

  const ChatItemCell({
    super.key,
    this.model,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatItemCellState();
  }
}

class _ChatItemCellState extends State<ChatItemCell> {
  UserInfo? get useInfo => IMConfig.userInfo;

  bool get isImg => widget.model?.contentType == 1;

  bool get isMe{
    if(widget.model?.groupNo?.isNotEmpty == true){
      if(widget.model?.sendNo == useInfo?.memberNo){
        return true;
      }else {
        return false;
      }
    }
    return useInfo?.memberNo != widget.model?.receiveNo;
  }

  String get chatContent {
    if(widget.model?.contentType == 6){
      return "消息撤回";
    }
    if (widget.model?.content?.isNotEmpty == true) {
      int length = widget.model?.content?.length ?? 0;
      if (widget.model!.content!.substring(length - 1, length) == "\n") {
        return widget.model!.content!.substring(0, length - 1);
      }
      return widget.model?.content ?? "";
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
  }

  void _sendTextMessage() async {
    widget.model?.sendStatus = 0;
    setState(() {});
    String? errorDesc = await IMApi.sendMsg(
      widget.model?.sendNo ?? "",
      widget.model?.content ?? "",
      widget.model?.contentType ?? 0,
    );
    if (errorDesc?.isNotEmpty != true) {
      widget.model?.sendStatus = 1;
    } else {
      widget.model?.sendStatus = 2;
    }
    setState(() {});
  }

  void _showImageScan(String imageUrl, {bool? isLocalPath}) {
    if (imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: (isLocalPath == true)
                  ? Image.file(
                      File(imageUrl),
                      width: MediaQuery.of(context).size.width,
                    )
                  : CustomNewImage(
                      imageUrl: imageUrl,
                      width: MediaQuery.of(context).size.width,
                    ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        double dx = details.globalPosition.dx;
        double dy = details.globalPosition.dy;
        widget.callback?.call(dx, dy);
      },
      child: _buildChatContent(),
    );
  }

  Widget _buildChatContent() {
    if ((widget.model?.contentType ?? 0) >= 6) {
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.center,
        child: Text(
          chatContent,
          style: const TextStyle(
            color: Color(0xff999999),
            fontSize: 12,
          ),
        ),
      );
    }
    if (isMe) {
      return _buildRightStyle();
    } else {
      return _buildLeftStyle();
    }
  }

  Widget _buildLeftStyle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTime(),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 50, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNewImage(
                  imageUrl: widget.model?.sendHeadImage ?? "",
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
                const SizedBox(width: 12),
                if (isImg)
                  InkWell(
                    onTap: () {
                      _showImageScan(widget.model?.content ?? "");
                    },
                    child: CustomNewImage(
                      imageUrl: widget.model?.content ?? "",
                      width: 173,
                      height: 96,
                    ),
                  )
                else
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xfff7f7f7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: RichTextWidget(
                        model: widget.model,
                        isMe: false,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightStyle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        children: [
          _buildTime(),
          Container(
            padding: const EdgeInsets.fromLTRB(50, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.model?.sendStatus == 0)
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: const CupertinoActivityIndicator(
                            color: Color(0xff000000),
                            radius: 8,
                          ),
                        ),
                      if (widget.model?.sendStatus == 1)
                        InkWell(
                          onTap: () {
                            _sendTextMessage();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: const Icon(
                              Icons.error_outline_outlined,
                              color: Color(0xfff51b1b),
                            ),
                          ),
                        ),
                      if (isImg)
                        InkWell(
                          onTap: () {
                            if (widget.model?.localImgPath?.isNotEmpty == true) {
                              _showImageScan(widget.model?.localImgPath ?? "");
                            } else {
                              _showImageScan(widget.model?.content ?? "");
                            }
                          },
                          child: (widget.model?.localImgPath?.isNotEmpty == true)
                              ? Image.file(
                                  File(widget.model!.localImgPath!),
                                  width: 173,
                                  height: 96,
                                )
                              : CustomNewImage(
                                  imageUrl: widget.model?.content,
                                  width: 173,
                                  height: 96,
                                ),
                        )
                      else
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xfff51b1b),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            child: RichTextWidget(
                              model: widget.model,
                              isMe: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CustomNewImage(
                  imageUrl: widget.model?.sendHeadImage,
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    if (widget.model?.isShowTime == true) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xfff7f7f7).withOpacity(0.42),
        ),
        child: Text(
          widget.model?.createTime ?? "",
          style: const TextStyle(
            color: Color(0xff999393),
            fontSize: 12,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
