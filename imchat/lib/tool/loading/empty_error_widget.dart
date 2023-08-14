import 'package:flutter/material.dart';

class EmptyErrorWidget extends StatefulWidget {
  final String? errorMsg;
  final String? errorMsg2;
  final VoidCallback? retryOnTap;
  const EmptyErrorWidget({super.key, this.errorMsg = "暂无数据", this.errorMsg2, this.retryOnTap});

  @override
  State<StatefulWidget> createState() {
    return EmptyErrorWidgetState();
  }
}

class EmptyErrorWidgetState extends State<EmptyErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("assets/images/no_data.png"),
              width: 200,
              height: 200,
            ),
           // Text(widget.errorMsg ?? "", style: const TextStyle(color: Colors.grey)),
            (widget.errorMsg2 != null
                ? Text(widget.errorMsg2 ?? "", style: const TextStyle(color: Colors.grey))
                : Container()),
            Visibility(
              visible: widget.retryOnTap != null,
              child: InkWell(
                onTap: widget.retryOnTap,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child:  Text(
                    "点击重试",
                    style: TextStyle(color: Colors.blue.withOpacity(0.5), fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
