
import 'package:flutter/material.dart';

class MarqueeTile extends StatefulWidget {

  final List<Widget> widgets;

  MarqueeTile({Key? key, required this.widgets}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarqueeTileState();
  }


}

class _MarqueeTileState extends State<MarqueeTile> with SingleTickerProviderStateMixin{

  final GlobalKey _scrollkey = GlobalKey();
  final GlobalKey _contextKey = GlobalKey();

   AnimationController? _controller;
   Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp){
      if(mounted) {
        setState(() {
          double contentWidth = _contextKey.currentContext?.size?.width ?? 0;
          double scrollWidth = _scrollkey.currentContext?.size?.width ?? 0;
          if(contentWidth > 0 && scrollWidth > 0) {
            _startAnimation(contentWidth, scrollWidth);
          }
        });
      }
      
    });
  }

  void _startAnimation(double contentWidth, double scrollWidth) {
    if(contentWidth <= 0 || scrollWidth <= 0){
      return;
    }
    // if(contentWidth < scrollWidth) {
    //   return; // 内容如果一屏内不开启滚动动画
    // }
    double rates = 12000; // 动画速率，一屏幕宽度12秒
    double animMilliseconds = (contentWidth/scrollWidth)*rates;
    int seconds = animMilliseconds ~/ 1000; // 动画时长
    
    if(_controller != null) { // 更新动画
      _controller?.reset();
      _controller?.duration = Duration(seconds: seconds);
      _controller?.repeat();
    }else {
      // 创建动画
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: seconds),
        animationBehavior: AnimationBehavior.preserve,
      );
      _animation?.removeListener(_animationListen);
      _animation = Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(-1, 0.0),
      ).animate(_controller!);
      _animation?.addListener(_animationListen);
      _controller?.repeat();
    }
  }

  void _animationListen() {
    setState(() {
    });
  }

  @override
  void didUpdateWidget (MarqueeTile oldWidget) {

    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp){
      if(mounted) {
        setState(() {
          double contentWidth = _contextKey.currentContext?.size?.width ?? 0;
          double scrollWidth = _scrollkey.currentContext?.size?.width ?? 0;
          _startAnimation(contentWidth, scrollWidth);
        });
      }
      
    });

  }

  @override
  Widget build(BuildContext context) {
  
    return SingleChildScrollView(
      key: _scrollkey,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: FractionalTranslation(
          translation:_animation?.value ?? const Offset(0, 0),
          child: Container(
            key: _contextKey,
            child: Row(
              children: widget.widgets,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animation?.removeListener(_animationListen);
    super.dispose();
  }
}
