import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../network/dio_base.dart';
import 'image_crypto.dart';


//const int _kDefaultSize = 1000;
//const int _kDefaultSizeBytes = 100 << 20;

typedef ImageCallback = void Function(String, Uint8List?);

class ImageManager {
  // 工厂模式
  factory ImageManager() => _getInstance();

  static ImageManager get instance => _getInstance();
  static ImageManager? _instance;

  static int _taskCount = 0;
  static final List<String> _taskQueue = [];
  static final _taskCallbackMap = <String, List<ImageCallback>>{};
  static final List<String> _taskNetOpQueue = [];
  static int maxTaskCount = 10;

  int maxCacheSize = 50;

  ImageManager._internal() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 1024*1024*40;
  }

  static ImageManager _getInstance() {
    _instance ??= ImageManager._internal();
    return _instance!;
  }

  // 正在加载中的图片队列
  //final Map<String, dynamic> _pendingImages = {};
  // 缓存队列
  final Map<String, Uint8List?> _cache = {};
  final List<String> _cacheKey = [];

  // 缓存数量上限(1000)
  // final int _maximumSize = _kDefaultSize;
  // 缓存容量上限 (100 MB)

  // 清除所有缓存
  void clearBySize({required int maxSize}) {
    if (_cacheKey.length > maxSize) {
      List<String> removeKey = [];
      for (int i = 0; i < _cacheKey.length - maxSize; i++) {
        removeKey.add(_cacheKey[i]);
      }
      for (int i = 0; i < removeKey.length; i++) {
        _cacheKey.remove(removeKey[i]);
        _cache.remove(removeKey[i]);
      }
    }
  }

  // 清除指定key对应的图片缓存
  bool evict(String key) {
    if (_cache[key] != null) {
      _cache.remove(key);
      return true;
    }
    return false;
  }

  Future<Uint8List?> loadImage(String url) async {
    if (url.isEmpty) {
      return null;
    }
    var imageBase = _cache[url];
    if (imageBase != null) {
      return imageBase;
    }
    imageBase = await ImageCrypto.loadAndDecrypt(url);
    if (imageBase != null && imageBase.length > 2048) {
      _cache[url] = imageBase;
      _cacheKey.add(url);
      clearBySize(maxSize:maxCacheSize);
    }
    // ImageCache cacheTest = PaintingBinding.instance.imageCache;
    // debugLog(cacheTest.currentSize);
    return imageBase;
  }

  void loadImageInQueue(String url, {ImageCallback? callback}) async {
    if (url.isEmpty) {
      if (callback != null) {
        callback(url, null);
      }
      return;
    }
    Uint8List? imageBase = _cache[url];
    if (imageBase != null) {
      if (callback != null) {
        callback(url, imageBase);
      }
    } else {
      if (_taskCount > maxTaskCount) {
        _taskQueue.remove(url);
        _taskQueue.add(url);
        if (callback != null) {
          if (_taskCallbackMap[url] == null) {
            _taskCallbackMap[url] = [callback];
          } else {
            _taskCallbackMap[url]?.remove(callback);
            _taskCallbackMap[url]?.add(callback);
          }
        }
        return;
      }
      if (_taskNetOpQueue.contains(url)) {
        if (_taskCallbackMap[url] == null) {
          _taskCallbackMap[url] == [callback];
        } else {
          if (callback != null) {
            _taskCallbackMap[url]?.remove(callback);
            _taskCallbackMap[url]?.add(callback);
          }
        }
        return;
      }
      // 开始任务
      _taskCount++;
      _taskNetOpQueue.add(url);
      try {
        imageBase = await ImageCrypto.loadAndDecrypt(url);
        if (imageBase != null) {
          _cache[url] = imageBase;
          _cacheKey.add(url);
          clearBySize(maxSize: maxCacheSize);
        }
      } catch (e) {
        debugLog(e);
      }
      if (callback != null) {
        callback(url, imageBase);
      }
      _taskCallbackMap[url]?.forEach((element) {
        element(url, imageBase);
      });
      _taskQueue.remove(url);
      _taskCallbackMap.remove(url);
      _taskNetOpQueue.remove(url);
      _taskCount--;
      for (int i = _taskCount; i <= maxTaskCount; i++) {
        if (_taskQueue.isNotEmpty) {
          String taskUrl = _taskQueue.first;
          _taskQueue.remove(taskUrl);
          try {
            ImageManager.instance.loadImageInQueue(taskUrl);
          } catch (e) {
            debugLog(e);
          }
        }
      }
    }
  }
}
