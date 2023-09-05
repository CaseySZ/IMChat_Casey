
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/contact/view/new_friend_view.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

import '../../tool/indicator/round_under_line_tab_indicator.dart';

class NewFriendPage extends StatefulWidget {

  const NewFriendPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewFriendPageState();
  }
}

class _NewFriendPageState extends State<NewFriendPage> with TickerProviderStateMixin{


  List<String> tabTitleArr = ["好友申请", "我的申请"];
  late TabController tabController = TabController(length: tabTitleArr.length, vsync: this);
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(
        titleWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          margin: const EdgeInsets.only(right: 56),
          child: TabBar(
            controller: tabController,
            tabs:  [
              Text(tabTitleArr[0]),
              Text(tabTitleArr[1]),
            ],
            labelColor:  Colors.black.withOpacity(0.8),
            unselectedLabelColor: const Color(0xff666666).withOpacity(0.8),
            labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            indicator: const RoundUnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 3,
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          NewFriendView(),
          NewFriendView(isMyApply: true),
        ],
      ),
    );
  }
}
