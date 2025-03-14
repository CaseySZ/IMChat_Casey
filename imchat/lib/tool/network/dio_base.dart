
// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/tool/network/response_status.dart';

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
    if(message2 != null) {
      if (message2 is String) {
        String logStr = message2;
        int maxLength = 526;
        if (logStr.length < maxLength) {
          print(message2);
        } else {
          for (int i = 0; i < logStr.length; i += maxLength) {
            if (i + maxLength < logStr.length) {
              print(logStr.substring(i, i + maxLength));
            } else {
              print(logStr.substring(i, logStr.length));
            }
          }
        }
      } else {
        print(message2);
      }
    }
  }

}

class DioBase {

  static List<Function> callbackArr = [];
  static addLister(Function callback) {
    callbackArr.add(callback);
  }
  static removeLister(Function callback) {
    callbackArr.remove(callback);
  }

  static String address = "http://8.217.117.185:9002";
  static const CONTENT_TYPE_JSON = "application/json";
  static DioBase? _instance;
  static DioBase get instance {
    _instance ??= DioBase()..init(address);
    return _instance!;
  }

  Dio? _dio;
  String? baseUrl;
  void init(String host) {
    final defaultOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 30000),
      validateStatus: (int? status) => status! < 600,
    );
    baseUrl = host;
    _dio = Dio(defaultOptions); // 使用默认配置
  }
  
  Future<Response?> post(String path, dynamic params, {Map<String, dynamic>? header}) async {

    try {
      if(params is Map) {
        params.removeWhere((key, value) => value == null);
      }
      header ??= {};
      Options? options;
      if(IMConfig.token?.isNotEmpty == true || header.isNotEmpty == true){
        if(IMConfig.token?.isNotEmpty == true) {
          header.addAll({"Authorization": IMConfig.token});
        }
        options = Options(headers: header);
      }
      Response? response = await _dio?.post((baseUrl ?? address) + path, data: params, options: options );
      debugLog("url:" +  (baseUrl ?? address) + path);
      debugLog(params.toString());
      debugLog(response);
      if(response?.tips == "令牌超时"){
        for (var element in callbackArr) {
          element.call();
        }
      }
      return response;
    }catch(e){
      debugLog("url:" +  (baseUrl ?? address) + path);
      debugLog(params.toString());
      debugLog(e);
      return Response(data: e, requestOptions: RequestOptions());
    }
  }

  Future get(String path, Map<String, dynamic>? params, {Map<String, dynamic>? header}) async {

    try {
      params?.removeWhere((key, value) => value == null);
      header ??= {};
      Options? options;
      if(IMConfig.token?.isNotEmpty == true || header.isNotEmpty == true){
        if(IMConfig.token?.isNotEmpty == true) {
          header.addAll({"Authorization": IMConfig.token});
        }
        options = Options(headers: header);
      }
      Response? response = await _dio?.get((baseUrl ?? address) + path, queryParameters: params, options: options);
      debugLog("url:" +  (baseUrl ?? address) + path);
      debugLog(params.toString());
      debugLog(response);
      return response;
    }catch(e){
      debugLog("url:" +  (baseUrl ?? address) + path);
      debugLog(params.toString());
      debugLog(e);
      return Response(data: e, requestOptions: RequestOptions());
    }
  }
}