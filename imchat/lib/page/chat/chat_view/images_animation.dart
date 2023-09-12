import 'dart:math';

import 'package:flutter/material.dart';

class ImagesAnimation extends StatefulWidget {
  final double w;
  final double h;
  final bool isLeftStyle;
  final ImagesAnimationEntry? entry;
  final int durationSeconds;

  const ImagesAnimation({
    Key? key,
    this.w = 80,
    this.h = 80,
    this.entry,
    this.durationSeconds = 3,
    this.isLeftStyle = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InState();
  }
}

class _InState extends State<ImagesAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: widget.durationSeconds))..repeat();
    _animation =  IntTween(begin: widget.entry?.lowIndex, end: widget.entry?.highIndex).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        String frame = _animation.value.toString();
        return Transform.rotate(
          //旋转90度
          angle: widget.isLeftStyle ? 0 : pi,
          child: Image.asset(
            "assets/images/cI$frame.png",
            gaplessPlayback: true, //避免图片闪烁
            width: widget.w,
            height: widget.h,
          ),
        );
      },
    );
  }


}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;
  ImagesAnimationEntry(this.lowIndex, this.highIndex);
}
