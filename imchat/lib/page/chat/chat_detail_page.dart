import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/alert/long_press_menu.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/soft_key_menu_view.dart';
import 'package:imchat/page/chat/group_detail_page.dart';
import 'package:imchat/page/chat/model/chat_record_model.dart';
import 'package:imchat/page/chat/person_detail_page.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:imchat/web_socket/web_socket_send.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/friend_item_info.dart';
import '../../tool/appbar/base_app_bar.dart';
import '../../tool/loading/loading_center_widget.dart';
import '../../tool/network/dio_base.dart';
import '../../tool/refresh/pull_refresh.dart';
import '../../utils/toast_util.dart';
import 'chat_view/album_picker_view.dart';
import 'chat_view/chat_item_cell.dart';
import 'chat_view/group_text_filed.dart';

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

  UserInfo? get userInfo => IMConfig.userInfo;

  int get chatType => widget.model?.targetType ?? 0; // 1 群聊
  String get friendNo => widget.model?.friendNo ?? widget.model?.targetNo ?? "";
  ChatRecordResponse? chatResponse;
  List<ChatRecordModel>? chatArr;
  int currentPage = 1;

  FocusNode focusNode = FocusNode();
  bool isShowSoftKeyboard = false;
  int softKeyType = -1; // 0 表情， 1 菜单
  bool isShowMenu = false;
  ChatRecordModel? menuChatModel;
  double menuDx = 0;
  double menuDy = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (chatType == 0) {
      WebSocketSend.sendOpenFriendBox(friendNo);
    } else {
      WebSocketSend.sendOpenGroupBox(friendNo);
    }
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
  }

  double keyboardSize = 277;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          // 关闭键盘
        } else {
          keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        }
      }
    });
  }

  void _loadData({String? startChatRecordId}) async {
    try {
      Response? response;
      if (chatType == 0) {
        response = await IMApi.getChatHistory(friendNo, startChatRecordId: startChatRecordId);
      } else {
        response = await IMApi.groupChatHistory(friendNo, startChatRecordId);
      }
      chatArr ??= [];
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

  void webSocketLister(Protocol protocol) {
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
      contentText = await FileAPi.updateImg(imageInfo.path ?? "") ?? "";
      if (contentText.isNotEmpty != true) {
        model.sendStatus = 1;
        setState(() {});
        return;
      }
    }
    String? errorDesc;
    if (chatType == 0) {
      errorDesc = await IMApi.sendMsg(friendNo, contentText, imageInfo == null ? 0 : 1);
    } else {
      errorDesc = await IMApi.sendGroupMsg(friendNo, contentText, imageInfo == null ? 0 : 1);
    }
    if (errorDesc?.isNotEmpty == true) {
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }
    setState(() {});
  }


  void _sendAudioMessage(String audioPath, {bool isVideo = false}) async {
    ChatRecordModel model = ChatRecordModel();
    model.content = audioPath;
    model.localPath = audioPath;
    model.contentType = isVideo ? 3 : 2;
    model.sendStatus = 0;
    model.sendNo = widget.model?.friendNo;
    model.sendHeadImage = userInfo?.headImage;
    chatArr?.insert(0, model);
    setState(() {});
    if(!isVideo){
      // 语音文件可能还在生成中
     await Future.delayed(const Duration(milliseconds: 1500));
    }
    String contentText = await FileAPi.updateFile(audioPath) ?? "";
    if (contentText.isNotEmpty != true) {
      model.sendStatus = 1;
      setState(() {});
      return;
    }
    String? errorDesc;
    if (chatType == 0) {
      errorDesc = await IMApi.sendMsg(friendNo, contentText, isVideo ? 3 : 2);
    } else {
      errorDesc = await IMApi.sendGroupMsg(friendNo, contentText, isVideo ? 3 :2);
    }
    if (errorDesc?.isNotEmpty == true) {
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }
    setState(() {});
  }

  void _backEvent() {
    if (chatType == 0) {
      WebSocketSend.sendCloseFriendBox(friendNo);
    } else {
      WebSocketSend.sendCloseGroupBox(friendNo);
    }
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
                              return ChatItemCell(
                                model: chatArr![index],
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 8, 10, 16),
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
                                          textInputAction: TextInputAction.send,
                                          focusNode: focusNode,
                                          placeholder: "请输入消息",
                                          onSubmitted: (text) {
                                            _sendTextMessage();
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
                              InkWell(
                                onTap: () => showSoftKeyboard(1),
                                child: SvgPicture.asset(
                                  softKeyType == 1 ? "assets/svg/close_btn.svg" : "assets/svg/add_red.svg",
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
                          audioCallback: _sendAudioMessage,
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
                          String relpyContent = "${menuChatModel?.sendNickName}：\"${menuChatModel?.chatContent} \"\n回复：";
                          eidtController.text = relpyContent;
                        }
                        menuChatModel = null;
                      },
                    ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    WebSocketModel.removeListener(webSocketLister);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
