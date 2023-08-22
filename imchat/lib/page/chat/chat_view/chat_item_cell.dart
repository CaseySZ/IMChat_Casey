import 'package:flutter/material.dart';

import '../../../tool/image/custom_new_image.dart';
import '../model/im_chat_data.dart';


class ChatItemCell extends StatefulWidget {
  final IMChatItemData? model;

  const ChatItemCell({super.key, this.model});

  @override
  State<StatefulWidget> createState() {
    return _ChatItemCellState();
  }
}

class _ChatItemCellState extends State<ChatItemCell> {
  bool get isImg => widget.model?.imgContent?.isNotEmpty == true;

  bool get isMe => false ;// GlobalStore.isMe(widget.model?.uid);

  @override
  void initState() {
    super.initState();
  }

  void _showImageScan(String imageUrl) {
    if(imageUrl.isNotEmpty) {
      showDialog(
        context: context,
          barrierDismissible:false,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Center(
              child: CustomNewImage(
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
        children: [
          _buildTime(),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 50, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNewImage(
                  imageUrl: widget.model?.avatar ?? "",
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
                const SizedBox(width: 12),
                if (isImg)
                  InkWell(
                    onTap: () {
                      _showImageScan(widget.model?.imgContent ?? "");
                    },
                    child: CustomNewImage(
                      imageUrl: widget.model?.imgContent ?? "",
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
                      child: Text(
                        widget.model?.content ?? "",
                        style: const TextStyle(
                          color: Color(0xff262424),
                          fontSize: 14,
                        ),
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
                if (isImg)
                  InkWell(
                    onTap: () {
                      _showImageScan(widget.model?.imgContent ?? "");
                    },
                    child: CustomNewImage(
                      imageUrl: widget.model?.imgContent ?? "",
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
                      child: Text(
                        widget.model?.content ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                CustomNewImage(
                  imageUrl: widget.model?.avatar,
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
          widget.model?.createAtDesc ?? "",
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
