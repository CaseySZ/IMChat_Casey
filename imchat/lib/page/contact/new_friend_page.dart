
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class NewFriendPage extends StatefulWidget {

  const NewFriendPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewFriendPageState();
  }
}

class _NewFriendPageState extends State<NewFriendPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(
        title: "好友请求".localize,
      ),
      body: Container(),
    );
  }
}
