import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';

class ChatMainPage extends StatefulWidget {

  const ChatMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatMainPageState();
  }
}

class _ChatMainPageState extends State<ChatMainPage> {


  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
      body: Container(
        child: InkWell(
          onTap: (){
            // casey13  32033208
            //99 casey99 40103237 , 10446501
           // IMApi.addFriend("casey13", "32033208");
            IMApi.addFriend("10446501", "11");
          },
          child: Container(color: Colors.red, width: 100, height: 100,),
        ),
      ),
    );
  }
}
