// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/alert/normal_alert.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/login_register/login_page.dart';
import 'package:imchat/page/mine/about_us_page.dart';
import 'package:imchat/page/mine/kefu_page.dart';
import 'package:imchat/page/mine/language_page.dart';
import 'package:imchat/page/mine/safe_setting_page.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/image/custom_new_image.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/web_socket/web_socket_send.dart';

import '../../model/user_info.dart';
import '../../utils/local_store.dart';
import 'my_collect_page.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  UserInfo? get userInfo => IMConfig.userInfo;

  @override
  void initState() {
    super.initState();
    Language.addListener(_langExchange);

  }

  void _langExchange() {
    if(mounted){
      setState(() {
      });
    }
  }

  void _exitLoginEvent() async {


    var ret = await NormalAlert.show(context,  content: "您确定要退出账号吗?".localize, buttonTitle: "取消".localize);
    if(ret != true) return;
    LoadingAlertWidget.show(context);
    try {
      LocalStore.removePassword();
      await IMApi.logout();
      IMConfig.token = null;
      IMConfig.memberRegisterCodeRequiredSwitch = 0;
      IMConfig.memberRegisterCodeSwitch = 0;
      await WebSocketSend.logout();
      LoadingAlertWidget.cancel(context);
    } catch (e) {
      LoadingAlertWidget.cancel(context);
      IMConfig.token = null;
      IMConfig.memberRegisterCodeRequiredSwitch = 0;
      IMConfig.memberRegisterCodeSwitch = 0;
      debugLog(e);
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const SizedBox(),
        title: "我的".localize,
      ),
      body: Column(
        children: [
          _buildHeadView(),
          buildLineWidget(height: 8),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const MyCollectPage();
              }));
            },
            child: _buildItem("我的收藏".localize, "", ""),
          ),
          buildLineWidget(height: 8),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const AboutUsPage();
              }));
            },
            child: _buildItem("关于我们".localize, "", ""),
          ),
          buildLineWidget(),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const SafeSettingPage();
              }));
            },
            child: _buildItem("安全设置".localize, "", ""),
          ),
          buildLineWidget(),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const LanguagePage();
              }));
            },
            child: _buildItem("切换语言".localize, "", ""),
          ),
          buildLineWidget(),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const KefuPage();
              }));
            },
            child: _buildItem("联系客服".localize, "", ""),
          ),
          buildLineWidget(),
          _buildItem("当前版本".localize, "", IMConfig.appVersion, showArrow: false),
          buildLineWidget(height: 8),
          InkWell(
            onTap: _exitLoginEvent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child:  Text(
                "退出登录".localize,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          buildLineWidget(height: 8),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String imagePath, String? content, {bool showArrow = true}) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Image.asset(
          //   imagePath,
          //   width: 12,
          // ),
          // const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              content ?? "",
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xffcccccc),
            ),
        ],
      ),
    );
  }

  Widget _buildHeadView() {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.mine_center);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        height: 60,
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: userInfo?.headImage,
              width: 56,
              height: 56,
              radius: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"昵称".localize}：${userInfo?.nickName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${"账号".localize}：${userInfo?.loginName}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff999999),
                    ),
                  ),
                  Text(
                    "ID：${userInfo?.memberNo}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xffcccccc),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Language.removeListener(_langExchange);
    super.dispose();
  }
}
