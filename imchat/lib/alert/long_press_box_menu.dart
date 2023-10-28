// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/utils/screen.dart';

import '../page/chat/model/chat_record_model.dart';
import '../utils/toast_util.dart';

class LongPressBoxMenu extends StatelessWidget {
  final double dx;
  final double dy;
  final Function(int)? callback;
  final ChatRecordModel? model;

  List<IconData> get iconArr => [
        Icons.copy,
        Icons.keyboard_return_rounded,
        Icons.keyboard_return_rounded,
        Icons.delete_outline,
      ];

  const LongPressBoxMenu({super.key, required this.dx, required this.dy, this.model, this.callback});

  double get height {
    return (model?.messageNum ?? 0) > 0 ? 40 * 2 : 40 ;
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

  Future _setTopMessageBox(BuildContext context) async {
    LoadingAlertWidget.show(context);
    String? errorStr;
    if (model?.groupNo?.isNotEmpty == true) {
      errorStr = await IMApi.chatMsgIsTop(model?.isTop == 1 ? 0 : 1, model?.groupNo, 1);
    } else {
      errorStr = await IMApi.chatMsgIsTop(model?.isTop == 1 ? 0 : 1, model?.targetNo, 1);
    }
    if (errorStr?.isNotEmpty == true) {
      showToast(msg: errorStr!);
    }
    LoadingAlertWidget.cancel(context);
  }

  Future _setReadedBox(BuildContext context) async {


  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback?.call(-1);
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
                      _buildItem(context, 0, model?.isTop == 1 ? "取消置顶".localize : "置顶该聊天".localize, ""),
                      //_buildItem(1, "转发", ""),
                      if ((model?.messageNum ?? 0) > 0) _buildItem(context, 2, "标为已读".localize, ""),
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
      onTap: () async {
        if (index == 0) {
          await _setTopMessageBox(context);
        } else if (title == "标为已读".localize) {
          await _setReadedBox(context);
        } else {}
        callback?.call(index);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff111111),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
