
import 'package:flutter/material.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class AddFriendPage extends StatefulWidget {

  const AddFriendPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddFriendPageState();
  }
}

class _AddFriendPageState extends State<AddFriendPage> {


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
        title: "添加好友",
      ),
      body: Container(),
    );
  }
}