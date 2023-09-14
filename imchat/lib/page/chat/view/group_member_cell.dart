import 'package:flutter/material.dart';
import 'package:imchat/model/friend_item_info.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';
import 'package:imchat/tool/image/custom_new_image.dart';

import '../../../routers/router_map.dart';
import '../model/chat_record_model.dart';
import '../model/group_member_model.dart';

class GroupMemberCell extends StatefulWidget {
  final GroupMemberModel? model;
  final Function(double, double)? callback;

  const GroupMemberCell({
    super.key,
    this.model,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _GroupMemberCellState();
  }
}

class _GroupMemberCellState extends State<GroupMemberCell> {
  GroupMemberModel? get model => widget.model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        double dx = details.globalPosition.dx;
        double dy = details.globalPosition.dy;
        widget.callback?.call(dx, dy);
      },
      child: InkWell(
        onTap: () async {},
        child: Container(
          height: 56,
          padding: const EdgeInsets.only(left: 16),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              CustomNewImage(
                imageUrl: model?.memberHeadImage,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    model?.nickNameRemark ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (model?.allowSendMessage == 1)
                                  const Icon(
                                    Icons.volume_off_sharp,
                                    color: Color(0xff999999),
                                    size: 16,
                                  )
                              ],
                            ),
                            Text(
                              "签名：${model?.memberPersonalitySign ?? ""}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xff999999), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (model?.memberType == 0)
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            color: const Color(0xfff2a73c),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "群主",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        )
                      else if (model?.memberType == 1)
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            color: const Color(0xfff2a73c),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "管理员",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        )
                      else
                        const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
