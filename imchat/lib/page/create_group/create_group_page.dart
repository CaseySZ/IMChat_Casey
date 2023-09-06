// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/group_text_filed.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/utils/toast_util.dart';

import '../chat/chat_view/album_picker_view.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupPageState();
  }
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Media> imageArr = [];

  @override
  void initState() {
    super.initState();
  }

  void _submitEvent() async {
    if (titleController.text.isEmpty) {
      showToast(msg: "请输入标题");
      return;
    }
    if (imageArr.isEmpty) {
      showToast(msg: "请选择群头像");
      return;
    }
    FocusScope.of(context).unfocus();
    LoadingAlertWidget.show(context);
    try{
      LoadingAlertWidget.showExchangeTitle("正在上传头像");
      String? headImage = await FileAPi.updateImg(imageArr.first.path ?? "");
      if(headImage?.isNotEmpty == true) {
        LoadingAlertWidget.showExchangeTitle("正在更新数据...");
        String? ret = await IMApi.groupCreate(headImage ?? "", titleController.text, descController.text);
        LoadingAlertWidget.cancel(context);
        if(ret?.isNotEmpty == true){
          showToast(msg: "群创建失败");
        }else {
          showToast(msg: "群创建成功");
          Navigator.pop(context);
        }
      }else {
        LoadingAlertWidget.cancel(context);
        showToast(msg: "头像上传失败");
      }
    }catch(e){
      LoadingAlertWidget.cancel(context);
      showToast(msg: "群创建失败");
      debugLog(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "创建群聊".localize,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Text(
                    "群名称",
                    style: TextStyle(color: Color(0xff666666), fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                      ),
                      child: GroupTextFiled(
                        controller: titleController,
                        placeholder: "请输入群名称",
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 6),
                    child: const Text(
                      "群公告",
                      style: TextStyle(color: Color(0xff666666), fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                      ),
                      child: GroupTextFiled(
                        alignment: Alignment.topRight,
                        controller: descController,
                        placeholder: "请输入群公告",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "群头像",
              style: TextStyle(color: Color(0xff666666), fontSize: 14),
            ),
            const SizedBox(height: 12),
            AlbumPickerView(
              callback: (images) {
                imageArr = images;
                setState(() {});
              },
              child: imageArr.isNotEmpty
                  ? Image.file(
                      File(imageArr.first.path ?? ""),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.8)),
                      child: Image.asset(
                        "assets/images/add_icon.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
            ),
            const SizedBox(height: 42),
            InkWell(
              onTap: _submitEvent,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  "创建",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
