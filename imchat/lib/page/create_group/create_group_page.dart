
import 'package:flutter/material.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class CreateGroupPage extends StatefulWidget {

  const CreateGroupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupPageState();
  }
}

class _CreateGroupPageState extends State<CreateGroupPage> {


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
        title: "查找用户",
      ),
      body: Container(),
    );
  }
}