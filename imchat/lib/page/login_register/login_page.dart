
import 'package:flutter/material.dart';
import 'package:imchat/tool/network/dio_base.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {
    DioBase.instance.post("/api/login", {"loginName":"casey11", "password":"123456"});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("登录", style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                  _loadData();
              },
              child: Container(
                width: 100,
                height: 50,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}