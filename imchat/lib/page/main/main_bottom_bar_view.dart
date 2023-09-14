import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/group_item_model.dart';
import '../../protobuf/model/base.pb.dart';
import '../../utils/screen.dart';
import '../../web_socket/web_message_type.dart';
import '../../web_socket/web_socket_model.dart';


class MainBottomBarView extends StatefulWidget {
  final List<String> titleArr;
  final PageController? pageController;

  const MainBottomBarView({super.key, required this.titleArr, this.pageController});

  @override
  State<StatefulWidget> createState() {
    return _MainBottomBarViewState();
  }
}

class _MainBottomBarViewState extends State<MainBottomBarView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WebSocketModel.addListener(webSocketLister);
  }

  int chatTargetMessageTotal = 0;
  int messageTotal = 0;

  int msgCount(int index){
    if(index == 0) {
      return chatTargetMessageTotal;
    }else if(index == 1){
      return friendApplyMessageTotal + groupApplyMessageTotal;
    }else {
      return 0;
    }
  }

  void webSocketLister(Protocol protocol) {
    if (protocol.cmd == MessageType.messageTotal.responseName && protocol.isSuccess == true) {
      chatTargetMessageTotal = protocol.data?["chatTargetMessageTotal"] ?? 0;
      friendApplyMessageTotal = protocol.data?["friendApplyMessageTotal"] ?? 0;
      groupApplyMessageTotal = protocol.data?["groupApplyMessageTotal"] ?? 0;
      messageTotal = protocol.data?["messageTotal"] ?? 0;
      setState(() {});
    }
    if (protocol.cmd == MessageType.groupList.responseName && protocol.isSuccess == true) {
      GlobalData.groupList = protocol.dataArr?.map((e) => GroupItemInfo.fromJson(e)).toList() ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + screen.paddingBottom,
      padding: EdgeInsets.only(bottom: screen.paddingBottom),
      child: Row(
        children: [
          _buildItem(0, currentIndex == 0),
          _buildItem(1, currentIndex == 1),
          _buildItem(2, currentIndex == 2),
          _buildItem(3, currentIndex == 3),
          //   _buildItem(4, currentIndex == 4),
        ],
      ),
    );
  }

  Widget _buildItem(int index, bool isSelected) {
    double width = screen.screenWidth / widget.titleArr.length;
    return InkWell(
      onTap: () {
        if (index != currentIndex) {
          widget.pageController?.jumpToPage(index);
          currentIndex = index;
          setState(() {});
        }
      },
      child: SizedBox(
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/root_menu_$index${(isSelected ? 1 : 0)}.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.titleArr[index],
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      color: isSelected ? Colors.blue : const Color(0xff434343)),
                ),
              ],
            ),
            if (msgCount(index) > 0)
              Positioned(
                left: width / 2 + 4,
                top: 5,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${msgCount(index)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WebSocketModel.removeListener(webSocketLister);
  }
}
