// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/page/chat/group_edit_txt_page.dart';
import 'package:imchat/page/chat/model/group_detail_model.dart';
import 'package:imchat/page/chat/view/group_setting_item.dart';
import 'package:imchat/page/create_group/group_add_friend_page.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/image/custom_new_image.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../api/file_api.dart';
import '../../tool/loading/loading_alert_widget.dart';
import '../../tool/network/dio_base.dart';
import 'chat_view/album_picker_view.dart';
import 'model/group_member_model.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupNo;
  final List<GroupMemberModel>? groupMemberArr;
  const GroupDetailPage({super.key, required this.groupNo, this.groupMemberArr,});

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

  void setHeadImageEvent() async {
    await checkPermissionAlways(context);
    List<Media> listMedia = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: const Color(0xfff21313)),
      galleryMode: GalleryMode.image,
      selectCount: 1,
      showCamera: true,
    );
    if (listMedia.isEmpty) {
      return;
    }
    LoadingAlertWidget.show(context);
    try {
      LoadingAlertWidget.showExchangeTitle("正在上传头像");
      String? headImage = await FileAPi.updateImg(listMedia.first.path ?? "");
      if (headImage?.isNotEmpty == true) {
        LoadingAlertWidget.showExchangeTitle("正在更新数据...");
        String? retStr = await IMApi.groupEdit(
          groupNo: groupModel?.groupNo,
          name: groupModel?.name,
          headImage: headImage,
          personalitySign: groupModel?.personalitySign,
          authInfo: groupModel?.groupAuth,
        );
        if (retStr?.isNotEmpty == true) {
          showToast(msg: retStr!);
        } else {
          groupModel?.localPath = listMedia.first.path;
          setState(() {});
        }
      } else {
        showToast(msg: "头像上传失败");
      }
      LoadingAlertWidget.cancel(context);
    } catch (e) {
      LoadingAlertWidget.cancel(context);
      showToast(msg: "更新头像失败");
      debugLog(e);
    }
  }

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
                onTap: () {
                  if (isAdmin) {
                    setHeadImageEvent();
                  }
                },
                child: groupModel?.localPath?.isNotEmpty == true
                    ? Image.file(
                        File(groupModel!.localPath!),
                        width: 80,
                        height: 80,
                  fit: BoxFit.cover,
                      )
                    : CustomNewImage(
                        imageUrl: groupModel?.headImage,
                        width: 80,
                        height: 80,
                      ),
              ),
              const SizedBox(height: 16),
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
            )
          else
            const Spacer(),
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
