import 'package:flutter/material.dart';
import 'package:imchat/page/add_friend/add_friend_page.dart';
import 'package:imchat/page/create_group/create_group_page.dart';
import 'package:imchat/utils/screen.dart';

class LongPressMenu extends StatelessWidget {

  final double dx;
  final double dy;
  final Function(int)? callback;
  const LongPressMenu({super.key, required this.dx, required this.dy, this.callback});

   double get realDy => dy - screen.paddingTop - kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback?.call(-1);
        },
        child: Stack(
          children: [
            Positioned(
              left: dx,
              top: realDy,
              child: Container(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (title == "添加好友") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddFriendPage();
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CreateGroupPage();
          }));
        }
      },
      child: Container(
        height: 40,
        width: 12,
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 30,
            ),
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
