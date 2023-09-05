import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';


class NoPermissionDialog extends StatelessWidget {

  static Future show(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const NoPermissionDialog();
        });
  }
  final String? msg;

  const NoPermissionDialog({Key? key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 280,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Text(
                "您已禁止权限，需要去设置页面手动开启才能继续".localize,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color(0xff363636),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1))),
                            child: InkWell(
                              child: Text(msg ?? "重试".localize),
                              onTap: () => Navigator.pop(context, false), // 关闭对话框
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1),
                                    left: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1))),
                            child: InkWell(
                              child:  Text(
                                "去设置".localize,
                                style: const TextStyle(color: Color(0xffFC3066)),
                              ),
                              onTap: () => Navigator.pop(context, true),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
