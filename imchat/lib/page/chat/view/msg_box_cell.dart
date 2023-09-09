import 'package:flutter/material.dart';
import 'package:imchat/model/friend_item_info.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';
import 'package:imchat/tool/image/custom_new_image.dart';

import '../../../routers/router_map.dart';
import '../model/chat_record_model.dart';

class MsgBoxCell extends StatefulWidget {
  final ChatRecordModel? model;

  const MsgBoxCell({super.key, this.model});

  @override
  State<StatefulWidget> createState() {
    return _MsgBoxCellState();
  }
}

class _MsgBoxCellState extends State<MsgBoxCell> {
  ChatRecordModel? get model => widget.model;

  String get chatContent {
    if (model?.contentType == 1) {
      return "【图片】";
    }
    if (model?.contentType == 2) {
      return "【语音】";
    }
    if (model?.contentType == 3) {
      return "【文件】";
    }
    if (model?.contentType == 4) {
      return "【红包】";
    }
    if (model?.contentType == 5) {
      return "【转账】";
    }
    if (model?.contentType == 6) {
      return "【消息回撤】";
    }
    return model?.chatContent ?? "";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FriendItemInfo itemModel = FriendItemInfo.fromJson({});
        itemModel.friendNo = model?.targetNo;
        itemModel.contentType = model?.contentType;
        itemModel.nickName = model?.nickName;
        itemModel.targetType = model?.targetType;
        var result = await Navigator.pushNamed(context, AppRoutes.chat_detail, arguments: itemModel);
        if (result is ChatRecordModel) {
          model?.contentType = result.contentType;
          model?.content = result.content;
          setState(() {});
        }
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: model?.sendHeadImage,
              width: 42,
              height: 42,
              radius: 6,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xfff1f1f1)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          model?.nickName ?? "",
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: model?.contentType == 0
                              ? RichTextWidget(
                                  model: model,
                                  textStyle: const TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 13,
                                  ),
                                )
                              : Text(
                                  chatContent,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 4),
                        if ((model?.messageNum ?? 0) > 0)
                          Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              model?.messageNum?.toString() ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
