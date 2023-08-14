import 'package:flutter/material.dart';

class LoadingAlertWidget extends StatefulWidget {
  final String? title;
  final bool canCancel;

  const LoadingAlertWidget({super.key, this.title, this.canCancel = false});

  static GlobalKey<_LoadingAlertWidgetState>? _globalKey;

  static show(BuildContext context, {String? title, bool canCancel = false}) {
    _globalKey = GlobalKey<_LoadingAlertWidgetState>();
    showDialog(
        context: context,
        builder: (context) {
          return LoadingAlertWidget(
              key: _globalKey, title: title, canCancel: canCancel);
        });
  }

  static showExchangeTitle(String title) {
    _globalKey?.currentState?._flushTitle(title);
  }

  static cancel(BuildContext context) {
    _globalKey = null;
    Navigator.of(context).pop();
  }

  @override
  State<StatefulWidget> createState() {
    return _LoadingAlertWidgetState();
  }
}

class _LoadingAlertWidgetState extends State<LoadingAlertWidget> {
  late String title;

  @override
  void initState() {
    super.initState();
    title = widget.title ?? "加载中...";
  }

  void _flushTitle(String text) {
    title = text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.canCancel == true) {
          LoadingAlertWidget._globalKey = null;
          return true;
        }
        return false;
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.black45,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[500],
                    valueColor: const AlwaysStoppedAnimation(Colors.white70),
                    strokeWidth: 2,
//              value: .5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
