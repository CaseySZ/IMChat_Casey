import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import '../../api/im_api.dart';
import '../../config/config.dart';
import '../../protobuf/model/base.pb.dart';
import '../../utils/local_store.dart';
import '../../utils/screen.dart';
import '../../utils/toast_util.dart';
import '../../web_socket/web_socket_send.dart';
import '../chat/chat_main_page.dart';
import '../contact/contact_main_page.dart';
import '../find/find_page.dart';
import '../mine/mine_page.dart';
import 'main_bottom_bar_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {

  bool mainPageInited = false;

  List<String> titleArr = [
    '消息',
    '通讯录',
    "发现",
    '我的',
  ];

  List<Widget> pageViewArr = [
    const ChatMainPage(),
    const ContactMainPage(),
    const FindPage(),
    const MinePage(),
  ];

  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WebSocketModel.addListener(_receiveMessage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loginEvent();
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugLog("AppLifecycleState.inactive");
        break;
      case AppLifecycleState.resumed:
        _appResumed();
        debugLog("AppLifecycleState.resumed");
        break;
      case AppLifecycleState.paused:
        debugLog("AppLifecycleState.paused");
        break;
      case AppLifecycleState.detached:
        debugLog("AppLifecycleState.detached");
        break;
    }
  }


  void _appResumed() {
    int current = DateTime.now().millisecondsSinceEpoch;
    if(current - WebSocketModel.preReceiveHeaderTimer > 6000){
      WebSocketModel.retryConnect();
    }
  }

  void _loginEvent() async{

    String? userName= await LocalStore.getLoginName();
    String? pwd = await  LocalStore.getPassword();
    if(userName?.isNotEmpty == true && pwd?.isNotEmpty == true) {
      String? errorDesc;
      if(IMConfig.token == null) {
        errorDesc = await IMApi.login(userName!, pwd!);
        if (errorDesc?.isNotEmpty == true) {
          showToast(msg: errorDesc!);
          return;
        }
      }
      await WebSocketSend.login();
      errorDesc =  await IMApi.appInfo();
      if(errorDesc?.isNotEmpty == true) {
        showToast(msg: errorDesc!);
        return;
      }
      mainPageInited = true;
      setState(() {});
    }
  }


  void _receiveMessage(Protocol protocol){
    if(protocol.cmd == MessageType.login.responseName){
      if(protocol.isSuccess){
        WebSocketModel.isConnectSocketSuccess = true;
      }else {
        WebSocketModel.isConnectSocketSuccess = false;
      }
      setState(() {});
    }
  }


  DateTime? lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime!) <
                const Duration(seconds: 1)) {
          lastPopTime = DateTime.now();
          showToast(msg: '再次点击退出'.localize);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight + screen.paddingBottom),
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return pageViewArr[index];
                },
                itemCount: pageViewArr.length,
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MainBottomBarView(
                titleArr: titleArr,
                pageController: pageController,
              ),
            ),
            _buildLoadingStatus(),
          ],
        ),
      ),
    );
  }


  Widget _buildLoadingStatus() {
    if(WebSocketModel.isConnectSocketSuccess == null || mainPageInited == false){
      return  InkWell(
        onTap: (){

        },
        child:const LoadingCenterWidget(),
      );
    }else if(WebSocketModel.isConnectSocketSuccess == false){
      return EmptyErrorWidget(
        errorMsg: "IM服务器连接失败",
        retryOnTap: () {

        },
      );
    }else {
      return const SizedBox();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WebSocketModel.removeListener(_receiveMessage);
    super.dispose();
  }
}
