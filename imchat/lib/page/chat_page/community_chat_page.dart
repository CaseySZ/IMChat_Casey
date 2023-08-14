import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../tool/appbar/base_app_bar.dart';
import '../../tool/loading/loading_center_widget.dart';
import '../../tool/network/dio_base.dart';
import '../../tool/refresh/pull_refresh.dart';
import '../../utils/toast_util.dart';
import 'chat_view/album_picker_view.dart';
import 'chat_view/chat_item_cell.dart';
import 'chat_view/group_text_filed.dart';

class CommunityChatPage extends StatefulWidget {
  final String? groupId;


  const CommunityChatPage({super.key, this.groupId});

  @override
  State<StatefulWidget> createState() {
    return _CommunityChatPageState();
  }
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  TextEditingController controller = TextEditingController();
  RefreshController refreshController = RefreshController();
  List<dynamic>? chatArr;
  int currentPage = 1;

  String? get groupId =>
      "64ca22c28888ec052da663be"; //widget.groupId ?? widget.groupModel?.id;
  FocusNode focusNode = FocusNode();
  bool isShowAlbumKeyboard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
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

  void _loadData({int page = 1, int size = 10}) async {
    try {
      // RespData? respData = await API().communityGroupChatRecord(
      //     id: groupId, pageNumber: page, pageSize: size);
      chatArr ??= [];
      currentPage = page;
      if (page == 1) {
        chatArr?.clear();
      }
      // if (respData?.isSuccess == true) {
      //   var response = CommunityChatResponse.fromJson(respData?.data);
      //   chatArr?.addAll(response.chats ?? []);
      //   if (response.hasNext == true) {
      //     refreshController.loadComplete();
      //   } else {
      //     refreshController.loadNoData();
      //   }
      // } else {
      //   refreshController.loadComplete();
      //   showToast(msg: respData?.tips());
      // }
    } catch (e) {
      refreshController.loadComplete();
      showToast(msg: e.toString());
      debugLog(e);
    }
    chatArr ??= [];
    _handleMessageTimeDesc();
    refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  void _handleMessageTimeDesc() {
    // CommunityChatItemData? preModel;
    // for (int i = 0; i < (chatArr?.length ?? 0); i++) {
    //   var model = chatArr![i];
    //   model.createAtDesc ??= DateTimeUtil.utc4iso(model.createdAt);
    //   if (model.isShowTime == null) {
    //     if (model.createAtDesc == preModel?.createAtDesc) {
    //       model.isShowTime = false;
    //     } else {
    //       model.isShowTime = true;
    //     }
    //   }
    //   preModel = model;
    // }
  }

  bool isUpLoadImg = false;

  void _sendTextMessage({Media? imageInfo}) async {
    // if (controller.text.isEmpty && imageInfo == null) return;
    // try {
    //   String sendMsg = controller.text;
    //   String imageUrl = "";
    //   RespData? respData;
    //   if (imageInfo != null) {
    //     isUpLoadImg = true;
    //     setState(() {});
    //     sendMsg = "";
    //     imageUrl =
    //         await FileUpLoadTool().uploadImage(imageInfo.path ?? "") ?? "";
    //     if (imageUrl.isEmpty) {
    //       showToast(msg: "图片发送失败");
    //       isUpLoadImg = false;
    //       setState(() {});
    //       return;
    //     }
    //     respData =
    //         await API().communitySendMsg(id: groupId, imgContent: imageUrl);
    //   } else {
    //     controller.text = "";
    //     respData =
    //         await API().communitySendMsg(id: groupId, textContent: sendMsg);
    //   }
    //   if (respData?.isSuccess == true) {
    //     CommunityChatItemData msgData = CommunityChatItemData();
    //     msgData.content = sendMsg;
    //     msgData.createdAt = respData?.time;
    //     msgData.uid = GlobalStore.getMe()?.id;
    //     msgData.avatar = GlobalStore.getMe()?.avatarUrl;
    //     msgData.imgContent = imageUrl;
    //     msgData.createAtDesc ??= DateTimeUtil.utc4iso(msgData.createdAt);
    //     if (chatArr!.isNotEmpty == true &&
    //         chatArr!.first.createAtDesc == msgData.createAtDesc) {
    //       chatArr!.first.isShowTime = false;
    //       msgData.isShowTime = true;
    //     }
    //     chatArr?.insert(0, msgData);
    //   } else {
    //     showToast(msg: respData?.tips());
    //   }
    // } catch (e) {
    //   showToast(msg: e.toString());
    // }
    // isUpLoadImg = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "聊天",
      ),
      body: chatArr == null ? const LoadingCenterWidget() : Column(
        children: [
          Expanded(
            child: pullRefresh(
              enablePullDown: false,
              onRefresh: _loadData,
              onLoading: () => _loadData(page: currentPage + 1),
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
                              placeholder: "请输入您要咨询的问题",
                              maxLines: 1,
                              onSubmitted: (text) {
                                _sendTextMessage();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Container(
                          //   width: 30,
                          //   height: 30,
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          // ),
                          // const SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: showAlbumKeyboard,
                    child: isUpLoadImg
                        ? Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xffeb5445),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 8,
                            ),
                          )
                        : SvgPicture.asset(
                            isShowAlbumKeyboard
                                ? "assets/svg/close_btn.svg"
                                : "assets/svg/add_red.svg",
                            width: 30,
                            height: 30,
                          ),
                  )
                ],
              ),
            ),
          ),
          if (isShowAlbumKeyboard)
            Container(
              height: 130,
              padding: const EdgeInsets.only(left: 28),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  AlbumPickerView(
                    callback: (imageArr) {
                      if (imageArr.isNotEmpty) {
                        if (isUpLoadImg) {
                          showToast(msg: "正在发送图片,请耐心等待");
                          return;
                        }
                        _sendTextMessage(imageInfo: imageArr.first);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/album_key.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "相册",
                          style: TextStyle(
                            color: Color(0xff666262),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
