// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/group_text_filed.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../api/im_api.dart';
import 'model/group_detail_model.dart';

class GroupEditTxtPage extends StatefulWidget {
  final GroupDetailModel? groupModel;
  final String? title;

  const GroupEditTxtPage({super.key, this.title, this.groupModel});

  @override
  State<StatefulWidget> createState() {
    return _GroupEditTxtPageState();
  }
}

class _GroupEditTxtPageState extends State<GroupEditTxtPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  bool get isTitle => widget.title == "群聊名称".localize;

  GroupDetailModel? get groupModel => widget.groupModel;

  @override
  void initState() {
    super.initState();
    if (isTitle) {
      controller.text = widget.groupModel?.name ?? "";
    } else {
      controller.text = widget.groupModel?.personalitySign ?? "";
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  void _loadData() async {
    if (controller.text.isEmpty) {
      showToast(msg: "请输入内容");
      return;
    }
    focusNode.unfocus();
    LoadingAlertWidget.show(context);
    String content = controller.text;
    String? retStr = await IMApi.groupEdit(
      groupNo: groupModel?.groupNo,
      name: isTitle ? content : null,
      personalitySign: isTitle ? null : content,
    );
    if (retStr?.isNotEmpty == true) {
      showToast(msg: retStr!);
    } else {
      if (isTitle) {
        groupModel?.name = content;
      } else {
        groupModel?.personalitySign = content;
      }
    }
    LoadingAlertWidget.cancel(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: isTitle ? 0 : 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                  height: isTitle ? 40 : 120,
                  child: GroupTextFiled(
                    alignment: isTitle ? Alignment.centerLeft : Alignment.topLeft,
                    controller: controller,
                    placeholder: "请入输入内容".localize,
                    focusNode: focusNode,
                  ),
                ),
                SizedBox(height: isTitle ? 40 : 40),
                InkWell(
                  onTap: _loadData,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "提交".localize,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.unfocus();
    super.dispose();
  }
}
