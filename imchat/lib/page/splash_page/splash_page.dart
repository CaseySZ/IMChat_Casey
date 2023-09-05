
// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/local_store.dart';

import '../../tool/network/dio_base.dart';
import '../../utils/screen.dart';
import '../../utils/toast_util.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }


}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      _loadData();
    });
  }

  void _loadData() async{

    Response? response = await DioBase.instance.post("/api/getSystemConfig", {});
    if(response?.isSuccess == true){
      IMConfig.memberRegisterCodeRequiredSwitch = response?.respData["memberRegisterCodeRequiredSwitch"] ?? 1;
      IMConfig.memberRegisterCodeSwitch = response?.respData["memberRegisterCodeSwitch"] ?? 1;
    }
    String? userName= await LocalStore.getLoginName();
    String? pwd = await  LocalStore.getPassword();
    if(userName?.isNotEmpty == true && pwd?.isNotEmpty == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
    }


  }
  
  @override
  Widget build(BuildContext context) {
    screen.configData(context);
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );

  }

}

