import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/tool/image/custom_new_image.dart';

import '../../model/user_info.dart';

class MinePage extends StatefulWidget {

  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {

  UserInfo? get  userInfo => IMConfig.userInfo;

  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          CustomNewImage(
            imageUrl: userInfo?.headImage,
            width: 90,
            height: 90,
          )
        ],
      ),
    );
  }
}
