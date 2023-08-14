import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide WaterDropHeader;

Widget pullRefresh(
    {required Widget child,
      required RefreshController refreshController,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
    bool enablePullUp = true,
    bool enablePullDown = true,
    String noDataText = "呀~已经到底了",
    }) {
  return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController,
      //header: const ClassicHeader(textStyle: TextStyle(color: COLORS),),
      onRefresh: () {
        onRefresh?.call();
      },
      onLoading: () {
        onLoading?.call();
      },
      child: child);
}
