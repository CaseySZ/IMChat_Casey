// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/album_picker_view.dart';
import 'package:imchat/page/chat/group_edit_txt_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../config/config.dart';
import '../../model/user_info.dart';
import '../../tool/image/custom_new_image.dart';
import '../../utils/screen.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LanguagePageState();
  }
}

class _LanguagePageState extends State<LanguagePage> {
  UserInfo? get userInfo => IMConfig.userInfo;

  int currentSelectIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<String> get typeArr {
    return [
      "中文",
      "英文",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "切换语言".localize),
      body: ListView.builder(
        itemCount: typeArr.length,
        itemBuilder: (context, index) {
          return _buildItem(typeArr[index], index);
        },
      ),
    );
  }

  Widget _buildItem(String title, int index) {
    return InkWell(
      onTap: () async {
        currentSelectIndex = index;
        setState(() {});
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xfff1f1f1)),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (currentSelectIndex == index)
              const Icon(
                Icons.task_alt,
                color: Colors.blueAccent,
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
