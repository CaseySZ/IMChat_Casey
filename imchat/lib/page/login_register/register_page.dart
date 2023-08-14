import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../chat_page/chat_view/group_text_filed.dart';

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
  @override
  void initState() {
    super.initState();
  }

  String checkData() {
    if (nameController.text.isEmpty) {
      return "请输入用户名";
    }
    if (psdController.text.isEmpty) {
      return "请输入登录密码";
    }
    if (nickController.text.isEmpty) {
      return "请输入昵称";
    }
    return "";
  }

  void _loadData() async {
    String errorStr = checkData();
    if (errorStr.isNotEmpty) {
      showToast(msg: errorStr);
      return;
    }

    String userName = nameController.text;
    String pwd = psdController.text;
    //{"loginName": "casey11", "password": "123456"}
    Response? response = await DioBase.instance.post(
      "/api/login",
      {
        "loginName": userName,
        "password": pwd,
      },
    );

    if(response?.isSuccess == true){
      IMConfig.token =  response?.respData;
    }else {
      showToast(msg: response?.tips ?? "");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 96),
                  Text(
                    "IM演示版".localize,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
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
                                keyboardType: TextInputType.number,
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "注册账号".localize,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "忘记密码?".localize,
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
                    child:  Text(
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
          Positioned(
            bottom: 16,
            child: Text(
              "${"版本号".localize}：v1.0.0",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
