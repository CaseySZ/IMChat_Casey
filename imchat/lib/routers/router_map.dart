// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:imchat/page/login_register/register_page.dart';
import 'package:imchat/page/mine/mine_center_page.dart';

import '../page/chat/chat_detail_page.dart';
import '../page/login_register/login_page.dart';
import '../page/main/main_page.dart';
import '../page/splash_page/splash_page.dart';


class AppRoutes {
  static const splash_page = "splash_page";
  static const main = "main";
  static const login = 'login';
  static const register = "register";
  static const mine_center = "mine_center";
  static const chat_detail = "chat_detail";
  static final routes = {
    splash_page: (context, {arguments}) => const SplashPage(),
    main: (context, {arguments}) => const MainPage(),
    login:(context, {arguments}) => const LoginPage(),
    register:(context, {arguments}) => const RegisterPage(),
    mine_center:(context, {arguments}) => const MineCenterPage(),
    chat_detail:(context, {arguments}) =>  ChatDetailPage(
      model: arguments,
    ),
  };

  static var onGenerateRoute = (RouteSettings settings) {
    // 获取声明的路由页面函数
    var pageBuilder = routes[settings.name];
    if (pageBuilder != null) {
      if (settings.arguments != null) {
        return MaterialPageRoute(builder: (context) {
          return pageBuilder(context, arguments: settings.arguments);
        });
      } else {
        return MaterialPageRoute(builder: (context) {
          return pageBuilder(context);
        });
      }
    }
    return null;
  };
}

