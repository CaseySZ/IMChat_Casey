// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../alert/no_permission_dialog.dart';
import '../../../tool/network/dio_base.dart';
import '../../../utils/toast_util.dart';

class AlbumPickerView extends StatefulWidget {
  final Widget child;
  final bool isVideo;
  final int maxCount;
  final Function(List<Media>)? callback;
  const AlbumPickerView({
    super.key,
    required this.child,
    this.isVideo = false,
    this.maxCount = 1,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _AlbumPickerViewState();
  }
}

class _AlbumPickerViewState extends State<AlbumPickerView> {

  @override
  void initState() {
    super.initState();
  }

  Future<PermissionStatus> canReadStorage() async{
    AndroidDeviceInfo androidDeviceInfo = await  DeviceInfoPlugin().androidInfo;
    String androidVersion = androidDeviceInfo.version.release;
    late PermissionStatus status;
    if(int.parse(androidVersion) <= 12){
      status = await Permission.storage.request();
    }else {
      status = await Permission.photos.request();
    }
    return status;
  }

  Future _checkPermissionAlways() async {
    if (!Platform.isAndroid) return;
    var status = await canReadStorage();
    if (status.isGranted) return;
    // 展示无权限，去设置的对话框
    var val = await NoPermissionDialog.show(context);
    if (val == true) {
      // 跳转到应用配置界面
      var isCanOpen =  await openAppSettings();
      debugLog("isCanOpen: $isCanOpen");
    }else {
      return await _checkPermissionAlways();
    }
  }

  void _pickerEvent() async {
    await _checkPermissionAlways();
    List<Media> listMedia = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: const Color(0xfff21313)),
      galleryMode: widget.isVideo ? GalleryMode.video : GalleryMode.image,
      selectCount: widget.maxCount,
      showCamera: true,
    );
    if(widget.isVideo == true && listMedia.isNotEmpty){
      String videoPath = listMedia.first.path ?? "";
      File videoFile = File(videoPath);
      int fileSize = videoFile.lengthSync();
      int sizeM = fileSize ~/ (1024 * 1024);
      if (sizeM > 150 || sizeM == 0) {
        showToast(msg: "请选择150M内的视频");
        return;
      }
    }
    if(listMedia.isEmpty){
      showToast(msg: widget.isVideo ?  "请选择视频" : "请选择图片");
      return;
    }
    if(widget.callback != null){
      widget.callback!(listMedia);
    }
  }
  ///获取视频时长
  Future<int> getVideoDuration(String localPath) async {
    const platform =  MethodChannel("com.yinse/device");
    int duration = 0;
    try {
      duration = await platform
          .invokeMethod("getVideoDuration", {'filePath': localPath});
    } on PlatformException {
      return duration;
    }
    return duration;
  }

  ///获取视频宽高比
   Future<String> getVideoRatio(String localPath) async {
    const platform =  MethodChannel("com.yinse/device");
    String ratioStr = '';
    try {
      ratioStr =
      await platform.invokeMethod("getVideoRatio", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return ratioStr;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickerEvent,
      child: widget.child,
    );
  }

}
