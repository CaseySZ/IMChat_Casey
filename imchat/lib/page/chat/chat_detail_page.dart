import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/alert/long_press_menu.dart';
import 'package:imchat/alert/normal_alert.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/reply_item_widget.dart';
import 'package:imchat/page/chat/chat_view/soft_key_menu_view.dart';
import 'package:imchat/page/chat/group_detail_page.dart';
import 'package:imchat/page/chat/model/chat_record_model.dart';
import 'package:imchat/page/chat/person_detail_page.dart';
import 'package:imchat/page/chat/view/marquee/marquee_tile.dart';
import 'package:imchat/page/chat/view/member_list_alert.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:imchat/web_socket/web_socket_send.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/collect_model.dart';
import '../../model/friend_item_info.dart';
import '../../model/group_item_model.dart';
import '../../tool/appbar/base_app_bar.dart';
import '../../tool/loading/loading_center_widget.dart';
import '../../tool/network/dio_base.dart';
import '../../tool/refresh/pull_refresh.dart';
import '../../utils/toast_util.dart';
import '../mine/my_collect_page.dart';
import 'chat_view/audio_pick_view.dart';
import 'chat_view/chat_item_audio_widget.dart';
import 'chat_view/chat_item_cell.dart';
import 'chat_view/group_text_filed.dart';
import 'model/group_detail_model.dart';
import 'model/group_member_model.dart';

class ChatDetailPage extends StatefulWidget {
  final FriendItemInfo? model;

  const ChatDetailPage({
    super.key,
    this.model,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatDetailPageState();
  }
}

class _ChatDetailPageState extends State<ChatDetailPage> with WidgetsBindingObserver {
  TextEditingController eidtController = TextEditingController();
  RefreshController refreshController = RefreshController();
  GroupDetailModel? groupModel;

  UserInfo? get userInfo => IMConfig.userInfo;

  int get chatType => widget.model?.targetType ?? 0; // 1 群聊
  String get friendNo => widget.model?.friendNo ?? widget.model?.targetNo ?? "";
  ChatRecordResponse? chatResponse;
  List<ChatRecordModel>? chatArr;
  ChatRecordModel? replyModel;
  List<GroupMemberModel> groupMemberArr = [];
  int currentPage = 1;

  FocusNode focusNode = FocusNode();
  bool isShowSoftKeyboard = false;
  int softKeyType = -1; // 0 表情， 1 菜单
  bool isShowMenu = false;
  ChatRecordModel? menuChatModel;
  double menuDx = 0;
  double menuDy = 0;
  double keyboardSize = 277;
  String inputPreText = "";
  @override
  void initState() {
    super.initState();
    isPlayingMedia = false;
    WidgetsBinding.instance.addObserver(this);
    sendOpenBoxMsg();
    WebSocketModel.addListener(webSocketLister);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus && isShowSoftKeyboard) {
        isShowSoftKeyboard = false;
        softKeyType = -1;
        setState(() {});
      }
    });
    eidtController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          // 关闭键盘
        } else {
          double height = MediaQuery.of(context).viewInsets.bottom;
          if (height > keyboardSize) {
            keyboardSize = height;
          }
        }
      }
    });
  }

  void sendOpenBoxMsg() {
    if (chatType == 0) {
      WebSocketSend.sendOpenFriendBox(friendNo);
    } else {
      WebSocketSend.sendOpenGroupBox(friendNo);
    }
  }

  void _loadData({String? startChatRecordId}) async {
    try {
      Response? response;
      if (chatType == 0) {
        response = await IMApi.getChatHistory(friendNo, startChatRecordId: startChatRecordId);
      } else {
        response = await IMApi.groupChatHistory(friendNo, startChatRecordId);
        _loadGroupData();
      }
      chatArr ??= [];
      if (startChatRecordId == null) {
        chatArr?.clear();
      }
      if (response?.isSuccess == true) {
        if (startChatRecordId == null) {
          chatArr?.clear();
        }
        chatResponse = ChatRecordResponse.fromJson(response?.respData);
        // addChatMessage(chatResponse?.data ?? []);
        if (chatResponse?.data?.isNotEmpty == true) {
          chatArr?.addAll(chatResponse?.data ?? []);
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
        handleChatMessage();
      } else {
        refreshController.loadComplete();
        showToast(msg: response?.tips ?? defaultErrorMsg);
      }
    } catch (e) {
      refreshController.loadComplete();
      showToast(msg: e.toString());
      debugLog(e);
    }
    chatArr ??= [];
    refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  void _loadGroupData() async {
    Response? response = await IMApi.groupInfo(friendNo);
    if (response?.isSuccess == true) {
      groupModel = GroupDetailModel.fromJson(response?.respData ?? {});
    } else {
      showToast(msg: response?.tips ?? defaultErrorMsg);
    }
    groupModel ??= GroupDetailModel();
    setState(() {});
  }

  void webSocketLister(Protocol protocol) {
    if (protocol.isSuccess == true && protocol.cmd == MessageType.login.responseName) {
      Future.delayed(const Duration(seconds: 1), () {
        sendOpenBoxMsg();
        _loadData();
      });
    }
    if (chatType == 0) {
      if (protocol.cmd == MessageType.chatHistory.responseName && protocol.isSuccess == true) {
        ChatRecordModel model = ChatRecordModel.fromJson(protocol.dataMap ?? {});
        if (model.receiveNo == widget.model?.friendNo || model.sendNo == widget.model?.friendNo) {
          handleChatMessage(list: [model]);
        }
      }
    } else {
      if (protocol.cmd == MessageType.chatGroupHistory.responseName && protocol.isSuccess == true) {
        ChatRecordModel model = ChatRecordModel.fromJson(protocol.dataMap ?? {});
        if (model.groupNo == widget.model?.friendNo) {
          handleChatMessage(list: [model]);
        }
      }
    }
    if (protocol.isSuccess == true && protocol.cmd == MessageType.chatRemove.responseName) {
      String? memberChatRecordId = protocol.dataMap?["memberChatRecordId"];
      for (ChatRecordModel item in (chatArr ?? [])) {
        if (item.id == memberChatRecordId) {
          chatArr?.remove(item);
          setState(() {});
          break;
        }
      }
    }
    if (protocol.isSuccess == true && protocol.cmd == MessageType.groupMessageDelete.responseName) {
      String? memberChatRecordId = protocol.dataMap?["groupChatRecordId"];
      for (ChatRecordModel item in (chatArr ?? [])) {
        if (item.id == memberChatRecordId) {
          chatArr?.remove(item);
          setState(() {});
          break;
        }
      }
    }
    if (protocol.isSuccess == true && protocol.cmd == MessageType.groupMember.responseName) {
      if (protocol.dataArr is List) {
        var memberArr = protocol.dataArr?.map((e) => GroupMemberModel.fromJson(e)).toList();
        groupMemberArr.clear();
        groupMemberArr.addAll(memberArr ?? []);
      }
    }
    if (protocol.cmd == MessageType.groupList.responseName && protocol.isSuccess == true && chatType == 1) {
      List<GroupItemInfo> groupList = protocol.dataArr?.map((e) => GroupItemInfo.fromJson(e)).toList() ?? [];
      bool isExist = false;
      for (var item in groupList) {
        if (item.groupNo == groupModel?.groupNo) {
          isExist = true;
        }
      }
      if (!isExist) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  void handleChatMessage({List<ChatRecordModel>? list}) {
    chatArr ??= [];
    if (list?.isNotEmpty == true) {
      chatArr?.insertAll(0, list ?? []);
    }
    ChatRecordModel? preModel;
    for (int i = 0; i < chatArr!.length; i++) {
      ChatRecordModel model = chatArr![i];
      if (model.createTime != null) {
        if (model.createTime == preModel?.createTime) {
          model.isShowTime = true;
          preModel?.isShowTime = false;
        } else {
          model.isShowTime = true;
        }
      }
      preModel = model;
    }
    chatArr?.removeWhere((element) => element.sendStatus == 0);
    setState(() {});
  }

  void showSoftKeyboard(int type) {
    if (softKeyType != type && type >= 0 && isShowSoftKeyboard) {
      softKeyType = type;
      setState(() {});
      return;
    }
    if (softKeyType == 0 && type == 0) {
      return;
    }
    if (isShowSoftKeyboard) {
      isShowSoftKeyboard = false;
      focusNode.requestFocus();
      softKeyType = -1;
    } else {
      focusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 250), () {
        isShowSoftKeyboard = true;
        softKeyType = type;
        setState(() {});
      });
    }
  }

  bool isUpLoadImg = false;

  void _sendTextMessage({Media? imageInfo}) async {
    if (eidtController.text.isEmpty && imageInfo == null) {
      showToast(msg: "请输入内容");
      return;
    }
    String contentText = eidtController.text;
    eidtController.text = "";
    ChatRecordModel model = ChatRecordModel();
    if (imageInfo != null) {
      model.localPath = imageInfo.path ?? "";
    } else {
      model.content = contentText;
    }
    model.sendStatus = 0;
    model.sendNo = widget.model?.friendNo;
    model.sendHeadImage = userInfo?.headImage;
    model.contentType = imageInfo == null ? 0 : 1;
    chatArr?.insert(0, model);
    setState(() {});
    if (imageInfo != null) {
      contentText = await FileAPi.updateImgEncry(imageInfo.path ?? "") ?? "";
      if (contentText.isNotEmpty != true) {
        model.sendStatus = -1;
        chatArr?.remove(model);
        setState(() {});
        return;
      }
      model.content = contentText;
    }
    String? errorDesc;
    if (chatType == 0) {
      errorDesc = await IMApi.sendMsg(friendNo, contentText, imageInfo == null ? 0 : 1, reply: replyModel);
    } else {
      errorDesc = await IMApi.sendGroupMsg(friendNo, contentText, imageInfo == null ? 0 : 1, reply: replyModel);
    }
    if (errorDesc?.isNotEmpty == true) {
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }
    replyModel = null;
    setState(() {});
  }

  void _sendCollectMsg(CollectModel collectModel) async {
    ChatRecordModel model = ChatRecordModel();
    model.content = collectModel.imageUrl;
    model.sendStatus = 0;
    model.sendNo = widget.model?.friendNo;
    model.sendHeadImage = userInfo?.headImage;
    model.contentType = 1;
    chatArr?.insert(0, model);
    setState(() {});
    String? errorDesc;
    if (chatType == 0) {
      errorDesc = await IMApi.sendMsg(friendNo, collectModel.imagePath ?? "", 1, reply: replyModel);
    } else {
      errorDesc = await IMApi.sendGroupMsg(friendNo, collectModel.imagePath ?? "", 1, reply: replyModel);
    }
    if (errorDesc?.isNotEmpty == true) {
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }
    replyModel = null;
    setState(() {});
  }

  void _sendAudioMessage(String audioPath, {bool isVideo = false}) async {
    ChatRecordModel model = ChatRecordModel();
    model.localPath = audioPath;
    model.contentType = isVideo ? 3 : 2;
    model.sendStatus = 0;
    model.sendNo = widget.model?.friendNo;
    model.sendHeadImage = userInfo?.headImage;
    chatArr?.insert(0, model);
    setState(() {});
    if (!isVideo) {
      // 语音文件可能还在生成中
      await Future.delayed(const Duration(milliseconds: 1500));
    }
    String contentText = await FileAPi.updateFileEncry(audioPath) ?? "";
    if (contentText.isNotEmpty != true) {
      model.sendStatus = -1;
      chatArr?.remove(model);
      setState(() {});
      return;
    }
    model.content = contentText;
    String? errorDesc;
    if (chatType == 0) {
      errorDesc = await IMApi.sendMsg(friendNo, contentText, isVideo ? 3 : 2, reply: replyModel);
    } else {
      errorDesc = await IMApi.sendGroupMsg(friendNo, contentText, isVideo ? 3 : 2, reply: replyModel);
    }
    if (errorDesc?.isNotEmpty == true) {
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }
    replyModel = null;
    setState(() {});
  }

  void _backEvent() {
    if (chatArr?.isNotEmpty == true) {
      Navigator.pop(context, chatArr?.first);
    } else {
      Navigator.pop(context);
    }
  }

  void _detailEvent() {
    if (chatType == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PersonDetailPage(
          model: widget.model,
        );
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GroupDetailPage(
          groupNo: widget.model?.friendNo ?? "",
          groupMemberArr: groupMemberArr,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _backEvent();
        return false;
      },
      child: Scaffold(
        appBar: BaseAppBar(
          title: widget.model?.nickName ?? "",
          onBack: _backEvent,
          elevation: 0.2,
          actions: [
            InkWell(
              onTap: _detailEvent,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 16, 6),
                child: const Icon(
                  Icons.more_horiz,
                  size: 30,
                  color: Color(0xff666666),
                ),
              ),
            ),
          ],
        ),
        body: chatArr == null
            ? const LoadingCenterWidget()
            : Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: pullRefresh(
                          enablePullDown: false,
                          onRefresh: _loadData,
                          onLoading: chatArr?.isNotEmpty == true
                              ? () {
                                  _loadData(startChatRecordId: chatArr?.last.id);
                                }
                              : null,
                          refreshController: refreshController,
                          child: ListView.builder(
                            itemCount: chatArr?.length ?? 0,
                            reverse: true,
                            itemBuilder: (context, index) {
                              int pre = index - 1;
                              ChatRecordModel? preModel;
                              if(pre >= 0 && chatType == 1){
                                preModel = chatArr![index - 1];
                              }
                              return ChatItemCell(
                                model: chatArr![index],
                                isGroup: chatType == 1,
                                preModel: preModel,
                                callback: (dx, dy) {
                                  isShowMenu = true;
                                  menuChatModel = chatArr![index];
                                  menuDx = dx;
                                  menuDy = dy;
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      if(replyModel != null)
                        ReplyItemWidget(replyModel: replyModel, callback: (){
                          replyModel = null;
                          setState(() {});
                        },),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 8, 10, 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xffececec), width: 0.5),
                          ),
                        ),
                        child: SizedBox(
                          height: 36,
                          child: Row(
                            children: [
                              AudioPickerView(
                                callback: _sendAudioMessage,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Image.asset(
                                    "assets/images/5S.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff8f9fa),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GroupTextFiled(
                                          bgColor: Colors.transparent,
                                          controller: eidtController,
                                          focusNode: focusNode,
                                          placeholder: "请输入消息",
                                          onSubmitted: (text) {

                                          },
                                          onChange: (text){
                                            if(chatType == 1 && "$inputPreText@" == text){
                                              MemberListAlert.show(context, groupMemberArr, callback: (model){
                                                if(model != null){
                                                  eidtController.text = "${eidtController.text}${model.nickNameRemark ?? ""} ";
                                                  inputPreText = eidtController.text;
                                                }
                                              });
                                            }
                                            inputPreText = text;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () => showSoftKeyboard(0),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: const Icon(
                                    Icons.emoji_emotions_outlined,
                                    size: 32,
                                  ),
                                ),
                              ),
                              if (eidtController.text.isNotEmpty)
                                InkWell(
                                  onTap: _sendTextMessage,
                                  child: Container(
                                    height: 30,
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "发送".localize,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                InkWell(
                                  onTap: () => showSoftKeyboard(1),
                                  child: SvgPicture.asset(
                                    "assets/svg/add_red.svg", //softKeyType == 1 ? "assets/svg/close_btn.svg" : "assets/svg/add_red.svg",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (isShowSoftKeyboard)
                        SoftKeyMenuView(
                          height: keyboardSize - 50,
                          isEmoji: softKeyType == 0,
                          collectCallback: () async{
                            var ret = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const MyCollectPage(fromChat: true);
                            }));
                            if (ret is CollectModel) {
                              _sendCollectMsg(ret);
                            }
                          },
                          emojiCallback: (value) {
                            eidtController.text = eidtController.text + value;
                          },
                          videoCallback: (videoInfo) {
                            _sendAudioMessage(videoInfo.path ?? "", isVideo: true);
                          },
                          pictureCallback: (imageArr) {
                            if (imageArr.isNotEmpty) {
                              if (isUpLoadImg) {
                                showToast(msg: "正在发送图片,请耐心等待");
                                return;
                              }
                              _sendTextMessage(imageInfo: imageArr.first);
                            }
                          },
                        ),
                    ],
                  ),
                  if (isShowMenu)
                    LongPressMenu(
                      dx: menuDx,
                      dy: menuDy,
                      model: menuChatModel,
                      callback: (value) {
                        isShowMenu = false;
                        setState(() {});
                        if (value == "回复".localize) {
                          replyModel = menuChatModel;
                        }
                        menuChatModel = null;
                      },
                    ),
                  if (chatType == 1 && groupModel?.personalitySign?.isNotEmpty == true)
                    Positioned(
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          NormalAlert.show(context, title: "公告", content: groupModel?.personalitySign);
                        },
                        child:Container(
                            height: 30,
                            padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                            color: Colors.black.withOpacity(0.7),
                            alignment: Alignment.centerLeft,
                          child:  MarqueeTile(
                            widgets: [
                              SizedBox(width: screen.screenWidth),
                              Text(
                                "公告：${groupModel?.personalitySign}      ",
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    isPlayingMedia = false;
    if (chatType == 0) {
      WebSocketSend.sendCloseFriendBox(friendNo);
    } else {
      WebSocketSend.sendCloseGroupBox(friendNo);
    }
    WebSocketModel.removeListener(webSocketLister);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
