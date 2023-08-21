import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import '../../protobuf/model/base.pb.dart';
import '../../utils/screen.dart';
import '../../utils/toast_util.dart';
import '../chat_page/chat_main_page.dart';
import '../contact_page/contact_main_page.dart';
import '../find_page/find_page.dart';
import '../mine/mine_page.dart';
import 'main_bottom_bar_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  late bool mainPageInited;

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
    WebSocketModel.addListener(_receiveMessage);
    _checkStatus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });

  }

  void _checkStatus() {
    Future.delayed(const Duration(seconds: 2), (){
      if(WebSocketModel.isConnectSocketSuccess == true){
        setState(() {});
      }
    });
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

  void _loadData() async {}

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
    if(WebSocketModel.isConnectSocketSuccess == null){
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
    WebSocketModel.removeListener(_receiveMessage);
    super.dispose();
  }
}
