import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/toast_util.dart';

import '../tool/network/dio_base.dart';

class FileAPi {

  static String getName(String absPath) {
    if (absPath.isEmpty) return absPath;
    absPath = Uri.parse(absPath).path;
    var start = absPath.lastIndexOf(Platform.pathSeparator);
    if (start <= 0 || (start == absPath.length - 1)) {
      return absPath;
    } else {
      return absPath.substring(start + 1);
    }
  }

  static String getNameSuffix(String absPath) {
    var name = getName(absPath);
    if (name.isEmpty) return name;
    var ar = name.split('.');
    if (ar.isEmpty) {
      return name;
    } else if (ar.length < 2) {
      return ar[0];
    } else {
      return ar[ar.length - 1];
    }
  }

  static Future<String?> updateImg(String imagePath) async {
    try {
      debugLog("开始上传----", imagePath);
      int  maxImageSize = 200*1024;
      var extent = getNameSuffix(imagePath);
      var name = '${DateTime.now().toIso8601String()}_${Random().nextInt(1024)}.$extent';
      Uint8List fileData = File(imagePath).readAsBytesSync();
      Uint8List compressFileData = await compressImageList(fileData, maxSize: maxImageSize, compressCount:3);
      FormData args = FormData.fromMap({
        'file': MultipartFile.fromBytes(compressFileData, filename: name),
      });
    //  DioBase dioBase = DioBase()..init(IMConfig.fileServerUrl ?? "");
      Response? response = await DioBase.instance.post("/api/upload/image", args);
      if(response?.isSuccess == true){
        return response?.respData["path"];
      } else {
        showToast(msg: response?.tips ?? defaultErrorMsg);
      }
    } catch (e) {
      debugLog(e);
      showToast(msg: e.toString());
    }
    return null;
  }

  static Future<String?> updateFile(String filePath) async {
    try {
      debugLog("开始上传----", filePath);
      int  maxImageSize = 200*1024;
      var extent = getNameSuffix(filePath);
      var name = '${DateTime.now().toIso8601String()}_${Random().nextInt(1024)}.$extent';
      Uint8List fileData = File(filePath).readAsBytesSync();
      FormData args = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileData, filename: name),
      });
      //  DioBase dioBase = DioBase()..init(IMConfig.fileServerUrl ?? "");
      Response? response = await DioBase.instance.post("/api/upload/file", args);
      if(response?.isSuccess == true){
        return response?.respData["path"];
      } else {
        showToast(msg: response?.tips ?? defaultErrorMsg);
      }
    } catch (e) {
      debugLog(e);
      showToast(msg: e.toString());
    }
    return null;
  }

  static Future<Uint8List> compressImageList(Uint8List list, {int maxSize = 200*1024, int compressCount = 0}) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 80,
      format: CompressFormat.jpeg,
    );
    debugLog("图片压缩原大小${list.length/1024}, ${result.length/1024}");
    if(result.length > maxSize && compressCount < 1) {
      return compressImageList(result, maxSize: maxSize, compressCount: compressCount -1);
    }
    return result;
  }

}