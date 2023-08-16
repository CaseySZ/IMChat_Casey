import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import '../../utils/screen.dart';
import '../../utils/toast_util.dart';
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
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const MinePage(),
  ];

  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
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
          ],
        ),
      ),
    );
  }
}
