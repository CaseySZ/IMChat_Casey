import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/page/contact/contact_msg_forward_page.dart';

import '../../../api/im_api.dart';
import '../../../model/collect_model.dart';
import '../../../tool/image/custom_new_image.dart';
import '../../../utils/toast_util.dart';

class CollectCellView extends StatelessWidget {
  final CollectModel model;
  final Function? callback;
  final bool fromChat;
  bool isCollectNetIng;

  CollectCellView({
    super.key,
    required this.model,
    this.callback,
    this.isCollectNetIng = false,
    this.fromChat = false,
  });

  void deleteEvent() async {
    if (isCollectNetIng) return;

    isCollectNetIng = true;
    String? errorStr = await IMApi.collectDelete(listId: [model.id ?? ""]);
    if (errorStr?.isNotEmpty == true) {
      showToast(msg: errorStr!);
    } else {
      callback?.call();
    }
    isCollectNetIng = false;
  }

  void senderMsg(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactMsgForwardPage(
        model: model,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNewImage(
            imageUrl: model.imageUrl,
            width: 173,
            placeholder: Container(
              width: 173,
              height: 90,
              color: const Color(0xff666666).withOpacity(0.2),
            ),
          ),
          const Spacer(),
          if(fromChat)
            ...[
              InkWell(
                onTap: (){
                  callback?.call();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: const Text(
                    "发送",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ]
          else
            ...[
              InkWell(
                onTap: deleteEvent,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: const Text(
                    "删除",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => senderMsg(context),
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: const Text(
                    "转发",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
        ],
      ),
    );
  }
}
