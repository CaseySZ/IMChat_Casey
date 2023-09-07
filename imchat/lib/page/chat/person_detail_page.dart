

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class PersonDetailPage extends StatefulWidget {
  final String friendNo;
  const PersonDetailPage({super.key, required this.friendNo,});

  @override
  State<StatefulWidget> createState() {
    return _PersonDetailPageState();
  }
}

class _PersonDetailPageState extends State<PersonDetailPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(title: "聊天信息",),
      body: Container(),
    );
  }
}