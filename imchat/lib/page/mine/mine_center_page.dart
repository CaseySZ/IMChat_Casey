// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/album_picker_view.dart';
import 'package:imchat/page/chat/group_edit_txt_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../config/config.dart';
import '../../model/user_info.dart';
import '../../tool/image/custom_new_image.dart';
import '../../utils/screen.dart';

class MineCenterPage extends StatefulWidget {
  const MineCenterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MineCenterPageState();
  }
}

class _MineCenterPageState extends State<MineCenterPage> {
  UserInfo? get userInfo => IMConfig.userInfo;

  @override
  void initState() {
    super.initState();
  }

  void _headImageEvent(String filePath) async {
    if(filePath.isEmpty) return;

    LoadingAlertWidget.show(context);
    String? headUrl;
    String? retString = await FileAPi.updateImg(filePath, callback: (url){
      headUrl = url;
    });
    if(retString?.isNotEmpty == true){
      retString =  await IMApi.userInfoSet(headImage: retString);
      if(retString?.isEmpty == true){
        userInfo?.headImage = headUrl;
        setState(() {});
        showToast(msg: "头像修改成功".localize);
      }else {
        showToast(msg: retString ?? defaultErrorMsg);
      }
    }
    LoadingAlertWidget.cancel(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "修改资料".localize),
      body: Column(
        children: [
          buildLineWidget(height: 8),
          _buildHeadView(),
          buildLineWidget(height: 8),
          _buildItem("用户ID".localize, "", userInfo?.memberNo, showArrow: false),
          buildLineWidget(height: 8),
          _buildItem("用户名".localize, "", userInfo?.loginName, showArrow: false),
          buildLineWidget(height: 8),
          _buildItem("昵称".localize, "", userInfo?.nickName),
          buildLineWidget(height: 8),
          _buildItem("个性签名".localize, "", userInfo?.personalitySign),
          buildLineWidget(height: 8),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String imagePath, String? content,
      {bool showArrow = true}) {
    return InkWell(
      onTap: () async{
        if(title == "昵称".localize) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GroupEditTxtPage(title: "修改昵称".localize, userInfo: userInfo,);
          }));
          setState(() {});
        }else if(title == "个性签名".localize) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GroupEditTxtPage(title: "个性签名".localize, userInfo: userInfo,);
          }));
          setState(() {});
        }else {

        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Image.asset(
            //   imagePath,
            //   width: 12,
            // ),
            // const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                content ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xffcccccc),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadView() {
    return AlbumPickerView(
      callback: (value) async {
        _headImageEvent(value.first.path ?? "");
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        height: 56,
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: userInfo?.headImage,
              width: 56,
              height: 56,
              radius: 28,
            ),
            const Spacer(),
            Text(
              "换头像".localize,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xffcccccc),
            ),
          ],
        ),
      ),
    );
  }
}
