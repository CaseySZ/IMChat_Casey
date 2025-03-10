// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/system_config.dart';
import 'package:imchat/page/login_register/user_rule_page.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../tool/loading/loading_alert_widget.dart';
import '../../utils/local_store.dart';
import '../../utils/screen.dart';
import '../../web_socket/web_socket_model.dart';
import '../chat/chat_view/group_text_filed.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController psdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    nameController.text = (await LocalStore.getLoginName()) ?? "";
    psdController.text = (await LocalStore.getPassword()) ?? "";
  }

  String checkData() {
    if (nameController.text.isEmpty) {
      return "请输入用户名".localize;
    }
    if (psdController.text.isEmpty) {
      return "请输入密码".localize;
    }
    return "";
  }

  void _loginEvent({bool isKeyLogin = false}) async {
    if (isKeyLogin) {
      FocusScope.of(context).unfocus();
      LoadingAlertWidget.show(context);
      String? errorDesc = await IMApi.autoLogin();
      LoadingAlertWidget.cancel(context);
      if (errorDesc?.isNotEmpty == true) {
        showToast(msg: errorDesc!);
      } else {
        IMConfig.isOneKeyLogin = true;
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    } else {
      String errorStr = checkData();
      if (errorStr.isNotEmpty) {
        showToast(msg: errorStr);
        return;
      }
      FocusScope.of(context).unfocus();
      LoadingAlertWidget.show(context);
      String userName = nameController.text;
      String pwd = psdController.text;
      //{"loginName": "casey11", "password": "123456"}
      String? errorDesc = await IMApi.login(userName, pwd);
      LoadingAlertWidget.cancel(context);
      if (errorDesc?.isNotEmpty == true) {
        showToast(msg: errorDesc!);
      } else {
        IMConfig.isOneKeyLogin = false;
        LocalStore.saveUserAndPwd(userName, pwd);
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
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
                    "IM聊天".localize,
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
                      Text(
                        "欢迎您!".localize,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                placeholder: "请输入密码".localize,
                                obscureText: true,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (allConfigBeModel?.memberAppRegisterSwitch != 1) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              var ret = await Navigator.pushNamed(context, AppRoutes.register);
                              if (ret is String) {
                                nameController.text = ret;
                              }
                            },
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
                            child: const Text(
                              "", // "忘记密码?".localize,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _loginEvent,
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
                        "登录".localize,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (allConfigBeModel?.memberAutoRegisterSwitch != 1)
                    InkWell(
                      onTap: () {
                        _loginEvent(isKeyLogin: true);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        child: Text(
                          "一键登录".localize,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${"版本号".localize}：v1.0.0",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
