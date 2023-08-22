import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/tool/image/custom_new_image.dart';

import '../../../model/friend_item_info.dart';

class ContactCellView extends StatefulWidget {
  final FriendItemInfo? model;

  const ContactCellView({
    super.key,
    this.model,
  });

  @override
  State<StatefulWidget> createState() {
    return _ContactCellViewState();
  }
}

class _ContactCellViewState extends State<ContactCellView> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.chat_detail, arguments: widget.model);
      },
      child: Container(
        height: 54,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          children: [
            const SizedBox(width: 16),
            CustomNewImage(
              imageUrl: widget.model?.headImage ?? "",
              width: 40,
              height: 40,
              radius: 6,
            ),
            const SizedBox(width: 12),
            _buildStatus(widget.model?.onLine ?? false),
            const SizedBox(width: 3),
            Text(
              "${widget.model?.nickName} (${widget.model?.friendNo})",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(bool isOnLine) {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isOnLine ? Colors.green : const Color(0xffaaaaaa),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
