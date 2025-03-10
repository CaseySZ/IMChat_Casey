import 'package:dio/dio.dart';

String defaultErrorMsg = "网络异常";
extension ResponseStatus on Response {


  bool get isSuccess {
    if(data is Map){
      return data["code"] == 200 || data["code"] == "200";
    }
    return false;
  }

  String? get tips {
    if(data is Map){
      return data["message"];
    }
    return null;
  }

  dynamic get respData {
    if(data is Map){
      return data["data"];
    }
    return data;
  }


}