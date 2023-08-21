import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/image/custom_new_image.dart';
import 'package:imchat/utils/screen.dart';

import '../../model/user_info.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  UserInfo? get userInfo => IMConfig.userInfo;

  @override
  void initState() {
    super.initState();
  }

  void _exitLoginEvent(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const SizedBox(),
        title: "我的".localize,
      ),
      body: Column(
        children: [
          _buildHeadView(),
          buildLineWidget(height: 8),
          _buildItem("关于我们", "", ""),
          buildLineWidget(),
          _buildItem("安全设置", "", ""),
          buildLineWidget(),
          _buildItem("切换语言", "", ""),
          buildLineWidget(),
          _buildItem("联系客服", "", ""),
          buildLineWidget(),
          _buildItem("当前版本", "", IMConfig.appVersion, showArrow: false),
          buildLineWidget(height: 8),
          InkWell(
            onTap: _exitLoginEvent,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                child: const Text(
                  "退出登录",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
            ),
          ),
          buildLineWidget(height: 8),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String imagePath, String? content,
      {bool showArrow = true}) {
    return InkWell(
      onTap: () {

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
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.mine_center);
        setState(() {});
      },
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo?.nickName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "账号：${userInfo?.memberNo}" ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
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
