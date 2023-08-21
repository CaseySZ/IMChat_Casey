import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

import '../../config/config.dart';
import '../../model/user_info.dart';
import '../../tool/image/custom_new_image.dart';
import '../../utils/screen.dart';

class MineCenterPage extends StatefulWidget {
  const MineCenterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MineCenterPageState();
  }
}

class _MineCenterPageState extends State<MineCenterPage> {
  UserInfo? get userInfo => IMConfig.userInfo;

  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "修改资料"),
      body: Column(
        children: [
          buildLineWidget(height: 8),
          _buildHeadView(),
          buildLineWidget(height: 8),
          _buildItem("用户名", "", userInfo?.memberNo, showArrow: false),
          buildLineWidget(height: 8),
          _buildItem("昵称", "", userInfo?.nickName),
          buildLineWidget(height: 8),
          _buildItem("个性签名", "", userInfo?.personalitySign),
          buildLineWidget(height: 8),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String imagePath, String? content,
      {bool showArrow = true}) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Image.asset(
            //   imagePath,
            //   width: 12,
            // ),
            // const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                content ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xffcccccc),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadView() {
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        height: 56,
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: userInfo?.headImage,
              width: 56,
              height: 56,
              radius: 28,
            ),
            const Spacer(),
            Text(
              "换头像".localize,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xffcccccc),
            ),
          ],
        ),
      ),
    );
  }
}
