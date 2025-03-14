import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Language.initData();
  runApp(RefreshConfiguration(
    headerBuilder: () => WaterDropHeader(
      complete: Text(
        "客官慢一点～".localize,
        style: TextStyle(color: Colors.black.withAlpha(128), fontSize: 12),
      ),
    ),
    footerBuilder: () => ClassicFooter(
      loadingIcon: const SizedBox(
        width: 20,
        height: 20,
        child: Center(
          child: CupertinoActivityIndicator(
            radius:13.0,
          ),
        ),
      ),
      loadingText: "加载中...".localize,
      canLoadingText: "松开加载更多...".localize,
      noDataText: "没有数据了".localize,
      idleText: "上拉加载更多".localize,
      textStyle: TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontSize: 12,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      ),
    ),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    return MaterialApp(
      debugShowCheckedModeBanner: false, //去掉右上角的debug字样
      initialRoute: AppRoutes.splash_page, //初始化的时候加载的路由
      //初始化的时候加载的路由
      //routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      locale: const Locale("zh", 'CH'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,//是Flutter的一个本地化委托，用于提供Material组件库的本地化支持
        GlobalWidgetsLocalizations.delegate,//用于提供通用部件（Widgets）的本地化支持
        GlobalCupertinoLocalizations.delegate,//用于提供Cupertino风格的组件的本地化支持
      ],
      supportedLocales: const [
        Locale("zh", 'CH'),
        Locale("en", 'US'),
      ],
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: const Color(0xfff21313),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "PingFang SC",
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}



//import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {

  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(),
    );
  }
}

