import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/api/file_api.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/soft_key_menu_view.dart';
import 'package:imchat/page/chat/model/chat_record_model.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
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


  const ChatDetailPage({super.key, this.model});

  @override
  State<StatefulWidget> createState() {
    return _ChatDetailPageState();
  }
}

class _ChatDetailPageState extends State<ChatDetailPage> with WidgetsBindingObserver{
  TextEditingController controller = TextEditingController();
  RefreshController refreshController = RefreshController();
  UserInfo? get userInfo => IMConfig.userInfo;
  String get friendNo => widget.model?.friendNo ?? widget.model?.targetNo ?? "";
  ChatRecordResponse? chatResponse;
  List<ChatRecordModel>? chatArr;
  int currentPage = 1;

  FocusNode focusNode = FocusNode();
  bool isShowAlbumKeyboard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WebSocketModel.addListener(webSocketLister);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }
  double keyboardSize = 277;
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        if(MediaQuery.of(context).viewInsets.bottom==0){
          // 关闭键盘
        }else{
          keyboardSize =  MediaQuery.of(context).viewInsets.bottom;
        }
      }
    });
  }

  void _loadData({String? startChatRecordId}) async {
    try {
      Response? response =  await IMApi.getChatHistory(friendNo, startChatRecordId: startChatRecordId);
      chatArr ??= [];
      if(response?.isSuccess == true){
        if(startChatRecordId == null){
          chatArr?.clear();
        }
        chatResponse = ChatRecordResponse.fromJson(response?.respData);
        // addChatMessage(chatResponse?.data ?? []);
        if(chatResponse?.data?.isNotEmpty == true){
          chatArr?.addAll(chatResponse?.data ?? []);
          refreshController.loadComplete();
        }else {
          refreshController.loadNoData();
        }
        handleChatMessage();
      }else {
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


  void webSocketLister(Protocol protocol){
     if(protocol.cmd == MessageType.chatMessage && protocol.isSuccess == true){
      List<ChatRecordModel> list = protocol.dataArr?.map((e) => ChatRecordModel.fromJson(e)).toList() ?? [];
      var myMessageList = list.where((element) => element.targetNo == widget.model?.friendNo && element.targetType == 0).toList();
      List<ChatRecordModel> removeList = [];
      for(int i = 0; i < myMessageList.length; i++){
        if (myMessageList[i].targetNo?.isNotEmpty == true) { // 自己发送的
          myMessageList[i].receiveNo = widget.model?.friendNo;
          for(int j = 0; j < (chatArr?.length ?? 0); j++){
            if(chatArr![j].sendStatus != null && chatArr![j].content ==  myMessageList[i].content) {
              chatArr![j].createTime = myMessageList[i].createTime;
              removeList.add(myMessageList[i]);
            }
          }
        }
        myMessageList[i].receiveNo = userInfo?.memberNo;
      }
      for(var model in removeList){
        myMessageList.remove(model);
      }
      handleChatMessage(list: myMessageList);
     }
  }

  void handleChatMessage({List<ChatRecordModel>? list}) {
    chatArr ??= [];
    if(list?.isNotEmpty == true) {
      chatArr?.insertAll(0, list ?? []);
    }
    ChatRecordModel? preModel;
    for(int i = 0; i < chatArr!.length; i++){
      ChatRecordModel model = chatArr![i];
      if(model.createTime != null) {
        if (model.createTime == preModel?.createTime) {
          model.isShowTime = true;
          preModel?.isShowTime = false;
        } else {
          model.isShowTime = true;
        }
      }
      preModel = model;
    }
    setState(() {});
  }

  void showAlbumKeyboard() {
    if (isShowAlbumKeyboard) {
      isShowAlbumKeyboard = false;
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 250), () {
        isShowAlbumKeyboard = true;
        setState(() {});
      });
    }
  }

  bool isUpLoadImg = false;

  void _sendTextMessage({Media? imageInfo}) async {
    if(controller.text.isEmpty && imageInfo == null){
      showToast(msg: "请输入内容");
      return;
    }
    String contentText =  controller.text;
    controller.text = "";
    ChatRecordModel model = ChatRecordModel();
    if(imageInfo != null){
      model.localImgPath = imageInfo.path ?? "";
    }else {
      model.content = contentText;
    }
    model.sendStatus = 0;
    model.sendNo = widget.model?.friendNo;
    model.sendHeadImage = userInfo?.headImage;
    model.contentType = imageInfo == null ? 0 : 1;
    chatArr?.insert(0, model);
    setState(() {});
    if(imageInfo != null){
      contentText =  await FileAPi.updateImg(imageInfo.path ?? "") ?? "";
      if(contentText.isNotEmpty != true){
        model.sendStatus = 1;
        setState(() {});
        return;
      }
    }
    String? errorDesc = await IMApi.sendMsg(friendNo, contentText, imageInfo == null ? 0 : 1);
    if(errorDesc?.isNotEmpty == true){
      model.sendStatus = 1;
      showToast(msg: errorDesc ?? defaultErrorMsg);
    }else {
      model.sendStatus = 2;

    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: widget.model?.nickName ?? "",
      ),
      body: chatArr == null ? const LoadingCenterWidget() : Column(
        children: [
          Expanded(
            child: pullRefresh(
              enablePullDown: false,
              onRefresh: _loadData,
              onLoading: chatArr?.isNotEmpty == true ? () {
                _loadData(startChatRecordId: chatArr?.last.id);
              } : null,
              refreshController: refreshController,
              child: ListView.builder(
                itemCount: chatArr?.length ?? 0,
                reverse: true,
                itemBuilder: (context, index) {
                  return ChatItemCell(
                    model: chatArr![index],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 10, 22),
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
                              controller: controller,
                              textInputAction: TextInputAction.send,
                              focusNode: focusNode,
                              placeholder: "请输入消息",
                              maxLines: 1,
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
                    onTap: showAlbumKeyboard,
                    child: SvgPicture.asset(
                      isShowAlbumKeyboard
                          ? "assets/svg/close_btn.svg"
                          : "assets/svg/add_red.svg",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isShowAlbumKeyboard)
            SoftKeyMenuView(
              height: keyboardSize - 50,
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
    );
  }

  @override
  void dispose() {
    WebSocketModel.removeListener(webSocketLister);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
