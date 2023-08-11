
// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

debugLog(Object? message, [Object? message2]) {
  if (kDebugMode) {
    if (message is String){
      String logStr = message;
      int maxLength = 526;
      if (logStr.length < maxLength){
        print(message);
      }else {
        for (int i = 0; i < logStr.length; i += maxLength) {
          if (i + maxLength < logStr.length){
            print(logStr.substring(i, i+maxLength));
          }else {
            print(logStr.substring(i, logStr.length));
          }
        }
      }
    }else {
      print(message);
    }
    if (message2 is String){
      String logStr = message2;
      int maxLength = 526;
      if (logStr.length < maxLength){
        print(message2);
      }else {
        for (int i = 0; i < logStr.length; i += maxLength) {
          if (i + maxLength < logStr.length){
            print(logStr.substring(i, i+maxLength));
          }else {
            print(logStr.substring(i, logStr.length));
          }
        }
      }
    }else {
      print(message2);
    }
  }
}

class DioBase {
  static String address = "http://8.217.117.185:9002";
  static const CONTENT_TYPE_JSON = "application/json";
  static DioBase? _instance;
  static DioBase get instance {
    _instance ??= DioBase()..init(address);
    return _instance!;
  }

  Dio? _dio;
  void init(String host) {
    final defaultOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      validateStatus: (int? status) => status! < 600,
    );
    _dio = Dio(defaultOptions); // 使用默认配置
  }
  
  Future post(String path, Map<String, dynamic>? params, {Map<String, dynamic>? header}) async {

    try {
      Response? response = await _dio?.post(address + path, data: params,);
      debugLog(response);
    }catch(e){
      debugLog(e);
    }
  }
}