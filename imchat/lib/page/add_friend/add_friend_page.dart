import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/add_friend/add_friend_cell.dart';
import 'package:imchat/page/chat/chat_view/group_text_filed.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../model/user_info.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddFriendPageState();
  }
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController controller = TextEditingController();
  List<UserInfo>? userInfoArr;

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  void _loadData() async {
    if (controller.text.isEmpty) {
      showToast(msg: "请输入内容");
      return;
    }
    if (_isLoading) {
      showToast(msg: "正在搜索中哦～");
      return;
    }
    _isLoading = true;
    setState(() {});
    FocusScope.of(context).unfocus();
    try {
      Response? response = await IMApi.searchUser(controller.text);
      userInfoArr ??= [];
      if (response?.isSuccess == true) {
        if (response?.respData["data"] is List) {
          userInfoArr?.clear();
          userInfoArr = (response!.respData["data"] as List).map((e) => UserInfo.fromJson(e)).toList();
        } else {
          showToast(msg: "未查到相关信息");
        }
      } else {
        showToast(msg: response?.tips ?? defaultErrorMsg);
      }
    } catch (e) {
      showToast(msg: defaultErrorMsg);
      debugLog(e);
    }
    userInfoArr ??= [];
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "搜索好友",
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(border: Border.all(color: const Color(0xfff1f1f1)), borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Expanded(
                    child: GroupTextFiled(
                      controller: controller,
                      placeholder: "请输入搜索的内容".localize,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (txt) {
                        _loadData();
                      },
                    ),
                  ),
                  InkWell(
                    onTap: _loadData,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: _isLoading
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 10,
                            )
                          : Text(
                              "查找".localize,
                              style: const TextStyle(
                                color: Color(0xff666666),
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (userInfoArr == null) {
      return const SizedBox();
    }
    if (userInfoArr?.isEmpty == true) {
      return  Container(
        padding:const  EdgeInsets.only(top: 100),
        child:  EmptyErrorWidget(
          errorMsg: "未找到相关好友".localize,
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: userInfoArr?.length ?? 0,
        itemBuilder: (context, index) {
          return AddFriendCell(model: userInfoArr![index]);
        },
      ),
    );
  }
}
