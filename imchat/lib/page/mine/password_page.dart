
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../api/im_api.dart';
import '../../tool/loading/loading_alert_widget.dart';
import '../../tool/network/response_status.dart';
import '../chat/chat_view/group_text_filed.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {

  TextEditingController controller = TextEditingController();
  TextEditingController copyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {
    if(controller.text.isEmpty){
      showToast(msg: "请输入密码".localize);
      return;
    }
    if(controller.text.length < 6){
      showToast(msg: "密码不能少于6位".localize);
      return;
    }
    if(controller.text != copyController.text){
      showToast(msg: "两次密码输入不一致".localize);
      return;
    }

    LoadingAlertWidget.show(context);
    String? retString =  await IMApi.userInfoSet(password: controller.text);
    if(retString?.isEmpty == true){
      showToast(msg: "密码修改成功".localize);
    }else {
      showToast(msg: retString ?? defaultErrorMsg);
    }
    LoadingAlertWidget.cancel(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "密码设置".localize,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                height:  40 ,
                child: GroupTextFiled(
                  controller: controller,
                  placeholder: "请输入新密码".localize,
                ),
              ),
              const  SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                height:  40 ,
                child: GroupTextFiled(
                  controller: copyController,
                  placeholder: "请重新输入新密码".localize,
                ),
              ),
              const SizedBox(height:  40),
              InkWell(
                onTap: _loadData,
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "提交".localize,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}
