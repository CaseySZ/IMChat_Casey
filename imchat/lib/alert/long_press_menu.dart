import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/utils/screen.dart';

import '../page/chat/model/chat_record_model.dart';
import '../utils/toast_util.dart';

class LongPressMenu extends StatelessWidget {
  final double dx;
  final double dy;
  final Function(String?)? callback;
  final ChatRecordModel? model;

  List<IconData> get iconArr => [
        Icons.copy,
        Icons.keyboard_return_rounded,
        Icons.keyboard_return_rounded,
        Icons.delete_outline,
        Icons.collections_sharp,
      ];

  LongPressMenu({super.key, required this.dx, required this.dy, this.model, this.callback, this.isCollectNetIng = false});

  bool get isTextType => model?.contentType == 0;

  bool get isImgType => model?.contentType == 1;

  double get height {
    if (isMy) {
      if (isTextType || isImgType) {
        return 40 * 3;
      } else {
        return 40 * 2;
      }
    } else {
      if (isTextType || isImgType) {
        return 40 * 2;
      } else {
        return 40;
      }
    }
  }

  bool get isMy {
    return model?.sendNo == IMConfig.userInfo?.memberNo;
  }

  double get realDy {
    double reY = dy - screen.paddingTop - kToolbarHeight;
    if (reY > height) {
      reY -= height;
    }
    return reY;
  }

  double get realDx {
    double reY = dx - 100;
    if (reY < 50) {
      reY = dx;
    }
    return reY;
  }

  void _deleteMsg() async {
    String? errorStr;
    if (model?.groupNo?.isNotEmpty == true) {
      errorStr = await IMApi.groupDeleteMsg(model?.groupNo ?? "", model?.id ?? "");
    } else {
      errorStr = await IMApi.chatMsgDelete(model?.id ?? "");
    }
    if (errorStr?.isNotEmpty == true) {
      showToast(msg: errorStr!);
    }
  }

  bool isCollectNetIng = false;

  void _collectMsg(BuildContext context) async {
    if (isCollectNetIng) return;
    callback?.call(null);
    isCollectNetIng = true;
    String? errorStr;
    if (model?.groupNo?.isNotEmpty == true) {
      errorStr = await IMApi.collectAdd(chatRecordId:model?.id, chatRecordType: 1);
    } else {
      errorStr = await IMApi.collectAdd(chatRecordId:model?.id, chatRecordType: 0);
    }
    if (errorStr?.isNotEmpty == true) {
      showToast(msg: errorStr!);
    } else {
      showToast(msg: "收藏成功".localize);
    }
    isCollectNetIng = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback?.call(null);
        },
        child: Stack(
          children: [
            Positioned(
              left: realDx,
              top: realDy,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: height,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 3.0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isTextType) _buildItem(context, 0, "复制内容".localize, ""),
                      //_buildItem(1, "转发", ""),
                      _buildItem(context, 2, "回复".localize, ""),
                      if (isMy) _buildItem(context, 3, "撤回消息".localize, ""),
                      if (isImgType) _buildItem(context, 4, "收藏".localize, ""),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, String title, String imagePath) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          Clipboard.setData(ClipboardData(text: model?.chatContent ?? ''));
          showToast(msg: "复制成功".localize);
          callback?.call(null);
        } else if (title == "撤回消息".localize) {
          _deleteMsg();
          callback?.call(null);
        } else if (title == "回复".localize) {
          callback?.call("回复".localize);
        } else if (index == 4) {
          _collectMsg(context);
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconArr[index],
              color: Colors.redAccent,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff111111),
              ),
            )
          ],
        ),
      ),
    );
  }
}
