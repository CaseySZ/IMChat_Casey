import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/add_friend/add_friend_page.dart';
import 'package:imchat/page/create_group/create_group_page.dart';

class HomeMenuAlert extends StatelessWidget {
  static show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const HomeMenuAlert();
        });
  }

  const HomeMenuAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.only(right: 16 + 8, top: kToolbarHeight / 2),
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildItem(context, "添加好友".localize, "assets/images/hN.png"),
                  _buildItem(context, "创建群聊".localize, "assets/images/Gn.9.png"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if(title == "添加好友".localize){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const  AddFriendPage();
          }));
        }else {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const  CreateGroupPage();
          }));
        }
      },
      child: Container(
        height: 40,
        width: 120,
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          children: [
            Image.asset(imagePath, width: 30,),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff666666),
              ),
            )
          ],
        ),
      ),
    );
  }
}
