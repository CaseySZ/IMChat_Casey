// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../network/dio_base.dart';
import 'image_cache_disk.dart';


class ImageCrypto {

  static Future<Uint8List?> loadAndDecrypt(String path) async {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.bytes,
    );
    var url = path;
    Response response;
    try {
      Uint8List? imageBytes = await ImageCacheDisk.get(url);
      if(imageBytes == null) {
        response = await Dio(options).get(url);
        imageBytes = Uint8List.fromList(response.data);
        ImageCacheDisk.save(url, response.data);
      }
      var decodeData =  imageBytes;
      if (!(url.contains('.gif') || url.contains('.GIF'))) {
        decodeData = await compressList(decodeData);
      }
      return decodeData;
    }on DioError catch (error) {
      debugLog("图片加载失败：$error");
      if(error.type == DioExceptionType.receiveTimeout){
        try {
          response = await Dio(options).get(url);
          var imageBytes = Uint8List.fromList(response.data);
          ImageCacheDisk.save(url, response.data);
          return imageBytes;
        }catch(e){
          debugLog("图片加载失败：$e");
        }
      }
    } catch (e) {
      // debugLog("dio image error url: $url -> $e");
      return null;
    }
    return null;
  }


  static Future<Uint8List> compressList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 400,
      minWidth: 800,
      quality: 98,
      format: CompressFormat.webp,
    );
    //print("压缩前大小-----" + list.length.toString());
    //print("压缩后大小-----" + result.length.toString());
    return result;
  }


}
