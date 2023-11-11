// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/chat_view/simple_recorder.dart';

class AudioPickerView extends StatefulWidget {
  final Widget child;
  final Function(String)? callback;

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

  void sendAudioMsg(String filePath) async {
    widget.callback?.call(filePath);
  }

  void _pickerEvent() async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleRecorder(
            callback: (filePath, isSend) {
              Navigator.pop(context);
              if (isSend == false && filePath.isNotEmpty) {
                _showAlert(filePath);
              } else if (filePath.isNotEmpty) {
                sendAudioMsg(filePath);
              }
            },
          );
        });
  }

  void _showAlert(String filePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Material(
          color: Colors.black.withOpacity(0.3),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 54),
                      child:  Text(
                        "已超过最长录音时间上限，录音已自动停止，需要发送吗".localize,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child:  Text(
                                "取消".localize,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              sendAudioMsg(filePath);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child:  Text(
                                "发送".localize,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickerEvent,
      child: widget.child,
    );
  }
}
