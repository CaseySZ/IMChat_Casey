import 'package:flutter/cupertino.dart';

class LoadingCenterWidget extends StatelessWidget {
  final Color? color;
  final double? radius;
  const LoadingCenterWidget({super.key,this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CupertinoActivityIndicator(
        color: color ?? const Color(0xfff21313),
        radius: radius ?? 20,
      ),
    );
  }
}
