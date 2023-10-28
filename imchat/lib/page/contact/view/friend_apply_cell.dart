// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/image/custom_new_image.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import '../../../model/friend_apply_model.dart';

class FriendApplyCell extends StatefulWidget {
  final FriendApplyModel? model;
  final bool isMyApply;

  const FriendApplyCell({super.key, this.model, this.isMyApply = false});

  @override
  State<StatefulWidget> createState() {
    return _FriendApplyCellState();
  }
}

class _FriendApplyCellState extends State<FriendApplyCell> {
  FriendApplyModel? get model => widget.model;

  bool get isMyApply => widget.isMyApply;

  String get chatContent {
    return model?.applyContent ?? "";
  }

  String? get friendDesc {
    if(model?.friendNickName?.isNotEmpty == true){
      return model?.friendNickName;
    }
    return model?.friendNo;
  }

  String get status {
    //（0申请中，1同意，2拒绝）
    if (model?.applyStatus == 0) {
      return "申请中".localize;
    }
    if (model?.applyStatus == 1) {
      return "同意".localize;
    }
    if (model?.applyStatus == 2) {
      return "拒绝".localize;
    }
    return "";
  }

  Color get statusColor {
    //（0申请中，1同意，2拒绝）
    if (model?.applyStatus == 0) {
      return Colors.amber;
    }
    if (model?.applyStatus == 1) {
      return Colors.green;
    }
    if (model?.applyStatus == 2) {
      return Colors.redAccent;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  void _loadData(int status) async {
    if(isLoading) return;
    isLoading = true;
    LoadingAlertWidget.show(context);
    Response? response =  await IMApi.addFriendAgree(status, model?.id ?? "");
    if(response?.isSuccess == true){
      model?.applyStatus = status;
      setState(() {});
    }
    LoadingAlertWidget.cancel(context);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: model?.memberHeadImage,
              width: 42,
              height: 42,
              radius: 6,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xfff1f1f1)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMyApply ? "${friendDesc ?? ""} " : "${model?.memberNickName ?? ""} ",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${"留言".localize}：$chatContent",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isMyApply)
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                        ),
                      )
                    else
                      _buildStatusButton(),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton() {
    if(model?.applyStatus == 0) {
      return Row(
        children: [
          InkWell(
            onTap: () => _loadData(2),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child:  Text("拒绝".localize, style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap:() => _loadData(1),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child:  Text("同意".localize, style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),),
            ),
          ),

        ],
      );
    }else if(model?.applyStatus == 1){
     return Text(
        "已同意".localize,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
        ),
      );
    }else {
      return Text(
        "已拒绝".localize,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
        ),
      );
    }
  }
}
