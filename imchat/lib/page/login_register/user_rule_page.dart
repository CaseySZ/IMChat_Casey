import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/network/dio_base.dart';

import '../../tool/appbar/base_app_bar.dart';

class UserRulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserRulePage();
  }
}

class _UserRulePage extends State<UserRulePage> {
  String ruleDesc = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      readDataFromBundle();
    });
  }

  void readDataFromBundle() async {
    try {
      ruleDesc = await rootBundle.loadString("assets/file/rule_desc");
      debugLog(ruleDesc);
    }catch(e){
      debugLog(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "用户协议".localize),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          ruleDesc,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
