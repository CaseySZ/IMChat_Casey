// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/page/chat/chat_view/simple_recorder.dart';


class AudioPickerView extends StatefulWidget {
  final Widget child;
  final Function()? callback;

  const AudioPickerView({
    super.key,
    required this.child,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPickerViewState();
  }
}

class _AudioPickerViewState extends State<AudioPickerView> {

  @override
  void initState() {
    super.initState();
  }


  void _pickerEvent() async {
    await showDialog(context: context, builder: (context){
      return SimpleRecorder();
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickerEvent,
      child: widget.child,
    );
  }
}
