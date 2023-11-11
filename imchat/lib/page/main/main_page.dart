import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/login_register/login_page.dart';
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
//import 'package:jpush_flutter/jpush_flutter.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  bool mainPageInited = false;
  VideoPlayerController? controller;
  List<String> get titleArr => [
    '消息'.localize,
    '通讯录'.localize,
    "发现".localize,
    '我的'.localize,
  ];

  List<Widget> pageViewArr = [
    const ChatMainPage(),
    const ContactMainPage(),
    const FindPage(),
    const MinePage(),
  ];

  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  String? debugLable = 'Unknown';
 // final JPush jpush = JPush();
  @override
  void initState() {
    super.initState();
  //  initPlatformState();
    try {
      controller = VideoPlayerController.asset("assets/audio/Gw.ogg");

      controller?.initialize();
    } catch (e) {
      controller = null;

      debugLog("声音初始化失败$e");
    }
    WidgetsBinding.instance.addObserver(this);
    WebSocketModel.addListener(_receiveMessage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loginEvent();
    });
    DioBase.addLister(_reLogin);
    Language.addListener(_langExchange);
    WebSocketModel.retryConnectCallback = retryConnectEvent;
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
        setBadgeCount(0);
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

  void retryConnectEvent(int pre, int cur){
    if(pre != cur && cur == 1){
      showToast(msg: "网络异常，正在重新连接...".localize);
    }
  }

  // Future<void> initPlatformState() async {
  //   String? platformVersion;
  //
  //   try {
  //     jpush.addEventHandler(
  //         onReceiveNotification: (Map<String, dynamic> message) async {
  //           debugLog("flutter onReceiveNotification: $message");
  //           setState(() {
  //             debugLable = "flutter onReceiveNotification: $message";
  //           });
  //         },
  //         onOpenNotification: (Map<String, dynamic> message) async {
  //           debugLog("flutter onOpenNotification: $message");
  //           setState(() {
  //             debugLable = "flutter onOpenNotification: $message";
  //           });
  //         },
  //         onReceiveMessage: (Map<String, dynamic> message) async {
  //           debugLog("flutter onReceiveMessage: $message");
  //           setState(() {
  //             debugLable = "flutter onReceiveMessage: $message";
  //           });
  //         },
  //         onReceiveNotificationAuthorization:
  //             (Map<String, dynamic> message) async {
  //           debugLog("flutter onReceiveNotificationAuthorization: $message");
  //           setState(() {
  //             debugLable = "flutter onReceiveNotificationAuthorization: $message";
  //           });
  //         },
  //         onNotifyMessageUnShow: (Map<String, dynamic> message) async {
  //           debugLog("flutter onNotifyMessageUnShow: $message");
  //           setState(() {
  //             debugLable = "flutter onNotifyMessageUnShow: $message";
  //           });
  //         },
  //         onInAppMessageShow: (Map<String, dynamic> message) async {
  //           debugLog("flutter onInAppMessageShow: $message");
  //           setState(() {
  //             debugLable = "flutter onInAppMessageShow: $message";
  //           });
  //         },
  //         onInAppMessageClick: (Map<String, dynamic> message) async {
  //           debugLog("flutter onInAppMessageClick: $message");
  //           setState(() {
  //             debugLable = "flutter onInAppMessageClick: $message";
  //           });
  //         },
  //         onConnected: (Map<String, dynamic> message) async {
  //           debugLog("flutter onConnected: $message");
  //           setState(() {
  //             debugLable = "flutter onConnected: $message";
  //           });
  //         });
  //   } catch (e) {
  //     platformVersion = 'Failed to get platform version. $e';
  //   }
  //
  //   jpush.setAuth(enable: true);
  //   jpush.setup(
  //     appKey: "96c94bf8e1dc88d526a7e363", //你自己应用的 AppKey
  //     channel: "theChannel",
  //     production: false,
  //     debug: true,
  //   );
  //   jpush.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));
  //
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   jpush.getRegistrationID().then((rid) {
  //     debugLog("flutter get registration id : $rid");
  //     setState(() {
  //       debugLable = "flutter getRegistrationID: $rid";
  //     });
  //   });
  //
  //   // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
  //   jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     debugLable = platformVersion;
  //   });
  // }

  void _langExchange() {
    if(mounted){
      setState(() {
      });
    }
  }

  void _reLogin() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }), (route) => false);
  }

  int prePlayTime = 0;

  void _playAudio() async {
    try {
      int curTime = DateTime
          .now()
          .millisecondsSinceEpoch;
      if (curTime - prePlayTime > 2000 && !isPlayingMedia) {
        prePlayTime = curTime;
        await controller?.seekTo(Duration.zero);
        controller?.play();
      }
    } catch (e) {
      controller = null;
      setState(() {});
      debugLog(e);
    }
  }

  void _appResumed() {
    setState(() {});
    int current = DateTime
        .now()
        .millisecondsSinceEpoch;
    if (current - WebSocketModel.preReceiveHeaderTimer > 6000) {
      WebSocketModel.retryConnect();
    }
  }

  void _loginEvent() async {
    if (IMConfig.isOneKeyLogin) {
      if (IMConfig.token != null) {
        await WebSocketSend.login();
        String? errorDesc = await IMApi.appInfo();
        if (errorDesc?.isNotEmpty == true) {
          showToast(msg: errorDesc!);
          return;
        }
        mainPageInited = true;
        setState(() {});
      } else {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    } else {
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
    if (protocol.cmd == MessageType.messageTotal) {
      int messageTotal = protocol.data?["messageTotal"] ?? 0;
      if (messageTotal > 0) {
        _playAudio();
      }
    }
    if (protocol.cmd == MessageType.login.responseName) {
      if (protocol.isSuccess) {
        WebSocketModel.isConnectSocketSuccess = true;
        if( WebSocketModel.retryConnectStatus == 1){
          WebSocketModel.retryConnectStatus = 0;
          showToast(msg: "重新连接成功".localize);
        }
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
            if (controller != null)
              Positioned(
                left: 20,
                top: 20,
                child: SizedBox(width: 10, height: 10, child: VideoPlayer(controller!)),
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
      return Container(
        color: Colors.white,
        child: EmptyErrorWidget(
          errorMsg: "IM服务器连接失败".localize,
          retryOnTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }), (route) => false);
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  void dispose() {
    DioBase.removeLister(_reLogin);
    Language.removeListener(_langExchange);
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    WebSocketModel.removeListener(_receiveMessage);
    WebSocketModel.retryConnectCallback = null;
    super.dispose();
  }
}
