import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutUsPageState();
  }
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "关于我们".localize,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 56),
        child: Column(
          children: [
            Image.asset(
              "assets/images/app_logo.png",
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              "IMChat",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "版本：v1.0.0",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            const Spacer(),
            const Text(
              "商务合作 QQ：4124123512",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
