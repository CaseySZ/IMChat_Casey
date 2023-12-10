// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/system_config.dart';
import 'package:imchat/page/login_register/user_rule_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/utils/toast_util.dart';

import '../chat/chat_view/group_text_filed.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController psdController = TextEditingController();
  TextEditingController nickController = TextEditingController();
  TextEditingController inviteCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String checkData() {
    if (nameController.text.isEmpty) {
      return "请输入用户名".localize;
    }
    if (psdController.text.isEmpty) {
      return "请输入登录密码".localize;
    }
    if (nickController.text.isEmpty) {
      return "请输入昵称".localize;
    }
    if (allConfigBeModel?.memberRegisterCodeSwitch == 0 && nickController.text.isEmpty) {
      return "请输入邀请码".localize;
    }
    return "";
  }

  void _loadData() async {
    String errorStr = checkData();
    if (errorStr.isNotEmpty) {
      showToast(msg: errorStr);
      return;
    }
    FocusScope.of(context).unfocus();
    LoadingAlertWidget.show(context);
    String userName = nameController.text;
    String pwd = psdController.text;
    String nickName = nickController.text;
    int deviceType = 2; // 1:andoid 2:ios 3:andoid_h5 4. ios_h5 5:pc
    if(Platform.isAndroid) {
      deviceType = 1;
    }
    Response? response = await DioBase.instance.post(
      "/api/register",
      {
        "loginName": userName,
        "password": pwd,
        "nickName": nickName,
        "deviceType":deviceType,
        "registerCode": inviteCodeController.text,
        "sex": 0,
      },
    );



    LoadingAlertWidget.cancel(context);
    if (response?.isSuccess == true) {
      showToast(msg: "注册成功".localize);
      Navigator.pop(context, userName);
    } else {
      showToast(msg: response?.tips ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "注册".localize),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffcccccc)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: GroupTextFiled(
                            controller: nameController,
                            placeholder: "请输入用户名".localize,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffcccccc)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: GroupTextFiled(
                            controller: psdController,
                            placeholder: "请输入登录密码".localize,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffcccccc)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_calendar,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: GroupTextFiled(
                            controller: nickController,
                            placeholder: "请输入您的昵称".localize,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(allConfigBeModel?.memberRegisterCodeSwitch == 0)
                    ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xffcccccc)),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.qr_code,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: GroupTextFiled(
                                controller: inviteCodeController,
                                placeholder: "请输入邀请码".localize,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]

                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      "我已阅读并接受".localize,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        pushToPage(context, UserRulePage());
                      },
                      child: Text(
                        "《用户协议》".localize,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _loadData,
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(colors: [
                      Color(0xff58a7ec),
                      Color(0xff4058f3),
                    ]),
                  ),
                  child: Text(
                    "注册".localize,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "已有账号？直接登录".localize,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
