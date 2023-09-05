import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/tool/refresh/pull_refresh.dart';
import 'package:imchat/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../model/friend_apply_model.dart';
import '../../../tool/loading/empty_error_widget.dart';
import 'friend_apply_cell.dart';

class NewFriendView extends StatefulWidget {
  final bool isMyApply;

  const NewFriendView({super.key, this.isMyApply = false});

  @override
  State<StatefulWidget> createState() {
    return _NewFriendViewState();
  }
}

class _NewFriendViewState extends State<NewFriendView> with AutomaticKeepAliveClientMixin{
  RefreshController controller = RefreshController();
  int currentPage = 1;
  List<FriendApplyModel>? friendArr;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData({int page = 1}) async {
    Response? response;
    if (widget.isMyApply == true) {
      response = await IMApi.getMyAddFriendList();
    } else {
      response = await IMApi.getAddMyFriendList();
    }
    if (response?.isSuccess == true) {
      friendArr ??= [];
      List? result;
      int pageSize = 10;
      if (response?.respData is Map && response?.respData["data"] is List) {
        result = response?.respData["data"];
        pageSize = response?.respData["pageSize"] ?? 10;
      } else {
        if (response?.respData is List) {
          result = response?.respData;
        }
      }
      result ??= [];
      if (page == 1) {
        friendArr?.clear();
      }
      friendArr?.addAll(result.map((e) => FriendApplyModel.fromJson(e)).toList());
      if (result.length < pageSize) {
        controller.loadNoData();
      } else {
        controller.loadComplete();
      }
    } else {
      controller.loadComplete();
      showToast(msg: response?.tips ?? defaultErrorMsg);
    }
    controller.refreshCompleted();
    friendArr ??= [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (friendArr == null) {
      return const LoadingCenterWidget();
    } else if (friendArr!.isEmpty) {
      return EmptyErrorWidget(
        retryOnTap: () {
          friendArr = null;
          _loadData();
          setState(() {});
        },
      );
    } else {
      return pullRefresh(
        refreshController: controller,
        onRefresh: _loadData,
        onLoading: () => _loadData(page: 2),
        child: ListView.builder(
          itemCount: friendArr?.length ?? 0,
          itemBuilder: (context, index) {
            return FriendApplyCell(model: friendArr![index], isMyApply: widget.isMyApply,);
          },
        ),
      );
    }
  }


}
