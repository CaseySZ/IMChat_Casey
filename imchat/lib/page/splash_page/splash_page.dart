
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:imchat/routers/router_map.dart';
import 'package:imchat/utils/local_store.dart';

import '../../utils/screen.dart';

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
    String userName = await LocalStore.getLoginName() ?? "";
    String password = await LocalStore.getPassword() ?? "";
    if(userName.isNotEmpty && password.isNotEmpty){
      
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

