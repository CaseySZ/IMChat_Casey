

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/view/group_setting_item.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

import '../../model/friend_item_info.dart';
import '../../tool/image/custom_new_image.dart';
import 'group_edit_txt_page.dart';

class PersonDetailPage extends StatefulWidget {
  final FriendItemInfo? model;
  const PersonDetailPage({super.key, required this.model,});

  @override
  State<StatefulWidget> createState() {
    return _PersonDetailPageState();
  }
}

class _PersonDetailPageState extends State<PersonDetailPage> {

  FriendItemInfo? get  model => widget.model;
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(title: "聊天信息".localize,),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              CustomNewImage(
                imageUrl: model?.headImage,
                width: 80,
                height: 80,
                radius: 40,
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("个性签名：${model?.personalitySign ?? ""}",),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupEditTxtPage(
                        model: model,
                        title: "修改备注".localize,
                      );
                    }));
                    setState(() {});
                },
                child: _buldItem(
                  "${"备注名".localize}：${model?.nickName ?? ""}",
                  rightTitle: "修改备注".localize,
                ),
              ),
              GroupSettingItem(
                model: model,
                title: "聊天置顶".localize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buldItem(String title, {String? rightTitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xfff1f1f1)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          if (rightTitle?.isNotEmpty == true)
            Expanded(
              child: Text(
                rightTitle ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xff999999),
                  fontSize: 12,
                ),
              ),
            )
          else
            const Spacer(),

            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xffcccccc),
              size: 16,
            )
        ],
      ),
    );
  }

}