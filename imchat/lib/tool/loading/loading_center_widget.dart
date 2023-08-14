import 'package:flutter/cupertino.dart';

class LoadingCenterWidget extends StatelessWidget {
  const LoadingCenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: Color(0xfff21313),
        radius: 20,
      ),
    );
  }
}
