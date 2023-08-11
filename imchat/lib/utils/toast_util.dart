import 'package:fluttertoast/fluttertoast.dart';

/// 显示统一的toast 无context
Future<bool?> showToast(
    {required String msg,
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.CENTER}) {
  if (msg.isEmpty == true) return Future.value(false);
  return Fluttertoast.showToast(
      msg: msg, gravity: gravity, toastLength: toastLength);
}
