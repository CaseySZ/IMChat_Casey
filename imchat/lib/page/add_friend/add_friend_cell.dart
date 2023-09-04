import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/group_text_filed.dart';
import 'package:imchat/tool/image/custom_new_image.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

class AddFriendCell extends StatefulWidget {
  final UserInfo? model;

  const AddFriendCell({
    super.key,
    this.model,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddFriendCellState();
  }
}

class _AddFriendCellState extends State<AddFriendCell> {

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;
  void loadData() async{
    if(_isLoading) return;
    _isLoading = true;
    FocusScope.of(context).unfocus();
    try {
      Response? respon = await IMApi.addFriend(widget.model!.memberNo!, controller.text);
      if(respon?.isSuccess == true){
        showToast(msg: "好友申请已发送，请耐心等待回复".localize);
      }else {
        showToast(msg: respon?.tips ?? defaultErrorMsg);
      }
    }catch(e){
      showToast(msg: defaultErrorMsg);
      debugLog(e.toString());
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff1f1f1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 54,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              children: [
                const SizedBox(width: 0),
                CustomNewImage(
                  imageUrl: widget.model?.headImage ?? "",
                  width: 40,
                  height: 40,
                  radius: 6,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${widget.model?.nickName} (${widget.model?.memberNo})",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                _buildAddButton(),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: GroupTextFiled(
              padding: const EdgeInsets.only(right: 10),
              controller: controller,
              placeholder: "请输入留言".localize,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: loadData,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(3),
        ),
        child:  Text(
          "添加".localize,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
