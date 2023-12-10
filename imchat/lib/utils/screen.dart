import 'package:flutter/material.dart';


var screen = _Screen();

class _Screen {


  double paddingLeft = 0.0;
  double paddingRight = 0.0;
  // 一般为状态栏高度
  double paddingTop = 0.0;
  //一般为底部操作栏高度
  double paddingBottom = 0.0;
  // 水平安全区域
  double _screenWidth = 0.0;
  // 垂直安全区域
  double _screenHeight = 0.0;

  double get screenWidth {
    return _screenWidth;
  }

  double get screenHeight {
    return _screenHeight;
  }

  void configData(BuildContext context){

    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    paddingLeft = MediaQuery.of(context).padding.left;
    paddingRight = MediaQuery.of(context).padding.right;
    paddingTop = MediaQuery.of(context).padding.top;
    paddingBottom = MediaQuery.of(context).padding.bottom;
  }
}

Widget buildLineWidget({double height = 1}){
  return Container(height: height, color: const Color(0xfff6f7fb),);
}

Future pushToPage(BuildContext context, Widget page,) async {
  return Navigator.push(context, MaterialPageRoute(builder: (context) {
    return page;
  }));
}