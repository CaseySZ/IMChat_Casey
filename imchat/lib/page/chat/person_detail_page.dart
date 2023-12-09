

// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/view/group_setting_item.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../model/friend_item_info.dart';
import '../../tool/image/custom_new_image.dart';
import 'group_edit_txt_page.dart';
import 'package:imchat/tool/network/response_status.dart';

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

  bool _isLoading = false;
  void _loadData() async {
    if(_isLoading) return;
    _isLoading = true;
    Response? ret =  await IMApi.deleteFriend(model?.friendNo ?? "");
    _isLoading = false;
    if(ret?.isSuccess == true){
      Navigator.popUntil(context, (route) => route.isFirst);
    }else {
      showToast(msg: "删除失败".localize);
    }
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
                child: Text("${"个性签名".localize}：${model?.personalitySign ?? ""}",),
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
              const SizedBox(height: 16),
              InkWell(
                onTap: _loadData,
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.lightBlueAccent,
                  ),
                  child:  Text("删除好友".localize, style:const TextStyle(color: Colors.white),),
                ),
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