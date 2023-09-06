

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class GroupDetailPage extends StatefulWidget {

  const GroupDetailPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroupDetailPageState();
  }
}

class _GroupDetailPageState extends State<GroupDetailPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(title: "群聊信息",),
      body: Container(),
    );
  }
}