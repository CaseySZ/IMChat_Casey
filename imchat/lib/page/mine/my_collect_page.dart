import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/mine/view/collect_cell_view.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/response_status.dart';

import '../../api/im_api.dart';
import '../../model/collect_model.dart';
import '../../tool/network/dio_base.dart';
import '../../utils/toast_util.dart';
import '../chat/model/chat_record_model.dart';

class MyCollectPage extends StatefulWidget {

  final bool fromChat;

  const MyCollectPage({super.key, this.fromChat = false});

  @override
  State<StatefulWidget> createState() {
    return _MyCollectPageState();
  }
}

class _MyCollectPageState extends State<MyCollectPage> {
  List<CollectModel>? modelArr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {
    try {
      Response? response = await IMApi.getCollect();
      modelArr ??= [];
      if (response?.isSuccess == true) {
        var retArr = (response?.respData as List?)?.map((e) => CollectModel.fromJson(e)).toList() ?? [];
        modelArr?.addAll(retArr);
      } else {
        showToast(msg: response?.tips ?? defaultErrorMsg);
      }
    } catch (e) {
      showToast(msg: e.toString());
      debugLog(e);
    }
    modelArr ??= [];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "我的收藏".localize,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (modelArr == null) {
      return const LoadingCenterWidget();
    } else if (modelArr?.isEmpty == true) {
      return EmptyErrorWidget(
        retryOnTap: () {
          modelArr = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return ListView.builder(
        itemCount: modelArr?.length ?? 0,
        padding: const EdgeInsets.only(top: 12),
        itemBuilder: (context, index) {
          var model = modelArr![index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: CollectCellView(
                  model: model,
                  fromChat: widget.fromChat,
                  callback: () {
                    if(widget.fromChat){
                      Navigator.pop(context, model);
                    }else {
                      modelArr?.remove(model);
                      setState(() {});
                    }
                  },
                ),
              ),
              Container(
                height: 6,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          );
        },
      );
    }
  }
}
