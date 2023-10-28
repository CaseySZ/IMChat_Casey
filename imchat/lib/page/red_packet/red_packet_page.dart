import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/group_text_filed.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class RedPacketPage extends StatefulWidget {
  const RedPacketPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RedPacketPageState();
  }
}

class _RedPacketPageState extends State<RedPacketPage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "发红包".localize),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [
                     Text(
                      "金额".localize,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Expanded(
                      child: GroupTextFiled(
                        controller: controller,
                        placeholder: "¥0.00",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
