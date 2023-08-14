import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../../network/dio_base.dart';


class ImageCacheDisk {

  static Future<Uint8List?> get(String path) async {
    var pathUrl = Uri.tryParse(path);
    String fileName = "";
    if (pathUrl?.path != null) {
      fileName = pathUrl?.path.replaceAll("/", "") ?? "";
    }
    if (fileName.isNotEmpty) {
      String filePath = "${await _findSavePath()}/$fileName";
      var imageFile = File(filePath);
      if (imageFile.existsSync()) {
        return imageFile.readAsBytes();
      }
    }
    return null;
  }

  static void save(String path, List<int> fileData) async {
    try {
      if(fileData.length < 2048){
        return;
      }
      var pathUrl = Uri.tryParse(path);
      String fileName = "";
      if (pathUrl?.path != null) {
        fileName = pathUrl?.path.replaceAll("/", "") ?? "";
      }
      if (fileName.isNotEmpty) {
        String filePath = "${await _findSavePath()}/$fileName";
        var imageFile = File(filePath);
        if (imageFile.existsSync()) {
          imageFile.deleteSync();
        }
        imageFile.writeAsBytes(fileData, mode: FileMode.write);
      }
    }catch(e){
      debugLog("图片存储失败");
      debugLog(e);
    }
  }

  static Future<String> _findSavePath() async {
    final directory = Platform.isAndroid
        ? await getTemporaryDirectory()
        : await getTemporaryDirectory();

    String saveDir = '${directory.path}/cacheImage';
    Directory root = Directory(saveDir);
    if (!root.existsSync()) {
      debugLog(saveDir);
      await root.create();
    }
    return saveDir;
  }

}