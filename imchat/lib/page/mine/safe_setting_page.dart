
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/mine/password_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

class SafeSettingPage extends StatefulWidget {
  const SafeSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SafeSettingPageState();
  }
}

class _SafeSettingPageState extends State<SafeSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "安全设置".localize,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const PasswordPage();
                }));
              },
              child: _buldItem("设置密码".localize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buldItem(String title, {String? rightTitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xfff1f1f1)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          if (rightTitle?.isNotEmpty == true)
            Expanded(
              child: Text(
                rightTitle ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xff999999),
                  fontSize: 12,
                ),
              ),
            )
          else
            const Spacer(),

          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xffcccccc),
            size: 16,
          )
        ],
      ),
    );
  }
}
