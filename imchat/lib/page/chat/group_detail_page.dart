import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/page/chat/group_edit_txt_page.dart';
import 'package:imchat/page/chat/model/group_detail_model.dart';
import 'package:imchat/page/chat/view/group_setting_item.dart';
import 'package:imchat/page/create_group/group_add_friend_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupNo;

  const GroupDetailPage({super.key, required this.groupNo});

  @override
  State<StatefulWidget> createState() {
    return _GroupDetailPageState();
  }
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  GroupDetailModel? groupModel;

  bool get isAdmin => groupModel?.isAdmin == 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {
    Response? response = await IMApi.groupInfo(widget.groupNo);
    if (response?.isSuccess == true) {
      groupModel = GroupDetailModel.fromJson(response?.respData ?? {});
    } else {
      showToast(msg: response?.tips ?? defaultErrorMsg);
    }
    groupModel ??= GroupDetailModel();
    setState(() {});
  }

  void _functionEvent(String title, bool isValue) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "群聊信息",
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (groupModel == null) {
      return const LoadingCenterWidget();
    } else if (groupModel?.groupNo == null) {
      return EmptyErrorWidget(
        retryOnTap: () {
          groupModel = null;
          _loadData();
          setState(() {});
        },
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  if (isAdmin) {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupEditTxtPage(
                        groupModel: groupModel,
                        title: "群聊名称",
                      );
                    }));
                    setState(() {});
                  }
                },
                child: _buldItem("群聊名称", rightTitle: groupModel?.name),
              ),
              InkWell(
                onTap: () async {
                  if (isAdmin) {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupEditTxtPage(
                        groupModel: groupModel,
                        title: "群公告",
                      );
                    }));
                    setState(() {});
                  }
                },
                child: _buldItem(
                  "群公告",
                  rightTitle: groupModel?.personalitySign,
                ),
              ),
              if (isAdmin) ...[
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupAddFriendPage(groupNo: widget.groupNo);
                    }));
                  },
                  child: _buldItem("群成员添加", rightTitle: ""),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupAddFriendPage(
                        groupNo: widget.groupNo,
                        isDelete: true,
                      );
                    }));
                  },
                  child: _buldItem("群成员删除", rightTitle: ""),
                ),
                GroupSettingItem(
                  groupModel: groupModel,
                  title: "允许全体发言",
                ),
                GroupSettingItem(
                  groupModel: groupModel,
                  title: "允许添加好友",
                ),
                GroupSettingItem(
                  groupModel: groupModel,
                  title: "允许成员退群",
                ),
                GroupSettingItem(
                  groupModel: groupModel,
                  title: "显示群全成员",
                ),
              ],
            ],
          ),
        ),
      );
    }
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
            ),
          if (isAdmin)
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
