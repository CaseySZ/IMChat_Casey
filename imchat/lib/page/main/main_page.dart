import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:video_player/video_player.dart';
import '../../api/im_api.dart';
import '../../config/config.dart';
import '../../protobuf/model/base.pb.dart';
import '../../utils/local_store.dart';
import '../../utils/screen.dart';
import '../../utils/toast_util.dart';
import '../../web_socket/web_socket_send.dart';
import '../chat/chat_main_page.dart';
import '../chat/chat_view/chat_item_audio_widget.dart';
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
  late VideoPlayerController controller;
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
    try {
      controller = VideoPlayerController.asset("assets/audio/Gw.ogg");
      controller.initialize();
    } catch (e) {
      debugLog("声音初始化失败$e");
    }
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
        IMConfig.isBackground = false;
        debugLog("AppLifecycleState.resumed");
        break;
      case AppLifecycleState.paused:
        IMConfig.isBackground = true;
        debugLog("AppLifecycleState.paused");
        break;
      case AppLifecycleState.detached:
        debugLog("AppLifecycleState.detached");
        break;
    }
  }

  int prePlayTime = 0;

  void _playAudio() async {
    int curTime = DateTime.now().millisecondsSinceEpoch;
    if (curTime - prePlayTime > 2000 && !isPlayingMedia && !IMConfig.isBackground) {
      prePlayTime = curTime;
      await controller.seekTo(Duration.zero);
      controller.play();
    }
  }

  void _appResumed() {
    setState(() {});
    int current = DateTime.now().millisecondsSinceEpoch;
    if (current - WebSocketModel.preReceiveHeaderTimer > 6000) {
      WebSocketModel.retryConnect();
    }
  }

  void _loginEvent() async {
    if(IMConfig.isOneKeyLogin){
      if (IMConfig.token != null) {
        await WebSocketSend.login();
        String? errorDesc = await IMApi.appInfo();
        if (errorDesc?.isNotEmpty == true) {
          showToast(msg: errorDesc!);
          return;
        }
        mainPageInited = true;
        setState(() {});
      }else {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }else {
      String? userName = await LocalStore.getLoginName();
      String? pwd = await LocalStore.getPassword();
      if (userName?.isNotEmpty == true && pwd?.isNotEmpty == true) {
        String? errorDesc;
        if (IMConfig.token == null) {
          errorDesc = await IMApi.login(userName!, pwd!);
          if (errorDesc?.isNotEmpty == true) {
            showToast(msg: errorDesc!);
            return;
          }
        }
        await WebSocketSend.login();
        errorDesc = await IMApi.appInfo();
        if (errorDesc?.isNotEmpty == true) {
          showToast(msg: errorDesc!);
          return;
        }
        mainPageInited = true;
        setState(() {});
      }
    }
  }

  void _receiveMessage(Protocol protocol) {

    if (protocol.cmd == MessageType.messageTotal ||
        protocol.cmd == MessageType.friendChatMessage ||
        protocol.cmd == MessageType.chatBoxMessage ||
        protocol.cmd == MessageType.chatHistory ||
        protocol.cmd == MessageType.chatGroupHistory) {
      _playAudio();
    }
    if (protocol.cmd == MessageType.login.responseName) {
      if (protocol.isSuccess) {
        WebSocketModel.isConnectSocketSuccess = true;
      } else {
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
        if (lastPopTime == null || DateTime.now().difference(lastPopTime!) < const Duration(seconds: 1)) {
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
            Positioned(
              left: 20,
              top: 20,
              child: SizedBox(width: 10, height: 10, child: VideoPlayer(controller)),
            ),
            Container(
              padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + screen.paddingBottom),
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
    if (WebSocketModel.isConnectSocketSuccess == null || mainPageInited == false) {
      return InkWell(
        onTap: () {},
        child: const LoadingCenterWidget(),
      );
    } else if (WebSocketModel.isConnectSocketSuccess == false) {
      return EmptyErrorWidget(
        errorMsg: "IM服务器连接失败",
        retryOnTap: () {},
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    WebSocketModel.removeListener(_receiveMessage);
    super.dispose();
  }
}
