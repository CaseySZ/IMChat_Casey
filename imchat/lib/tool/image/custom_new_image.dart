// ignore_for_file: library_prefixes, depend_on_referenced_packages

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../network/dio_base.dart';
import 'image_data_handle/image_manager.dart';
import 'package:path/path.dart' as Path;

class CustomNewImage extends StatefulWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final bool? fullImg;
  final bool? isGauss;

  final BorderRadius? borderRadius;
  final double? radius;
  final bool? useQueue;
  final double? placePadding;

  const CustomNewImage({
    @required this.imageUrl,
    Key? key,
    this.radius,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.borderRadius,
    this.useQueue = false,
    this.placePadding,
    this.fullImg = false,
    this.isGauss = false,
    this.errorWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomNewImageState();
  }
}

class _CustomNewImageState extends State<CustomNewImage> {
  Uint8List? _imageBase;
  bool _loadingFinish = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadImage();
    });
  }

  @override
  void didUpdateWidget(covariant CustomNewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        (_loadingFinish && _imageBase == null)) {
      _loadImage();
    }
  }

  String get _realImageUrl {
    if (widget.imageUrl == null || widget.imageUrl?.isEmpty == true) {
      return "";
    }
    if (widget.imageUrl?.startsWith("http") == true ||
        widget.imageUrl?.startsWith("https") == true) {
      return widget.imageUrl ?? "";
    }else{
      return  widget.imageUrl ?? ""; //'${GlobalStore.getImgDomain()}/${widget.imageUrl}';
    }

    ///需要大图且不高斯
    // if (widget.fullImg == true && widget.isGauss == false) {
    //   var imgPath = Path.join(Address.baseImagePath ?? "", widget.imageUrl);
    //   return imgPath;
    // }
    // String rootPath = Path.join(Address.baseImagePath ?? "", "imageView/1");
    // if (widget.width != null &&
    //     widget.height != null &&
    //     widget.fullImg != true &&
    //     widget.width?.isInfinite != true &&
    //     widget.width?.isNaN != true &&
    //     widget.height?.isNaN != true &&
    //     widget.height?.isInfinite != true) {
    //   rootPath = Path.join(rootPath, "w/${widget.width}/h/${widget.height}");
    // }
    // if (widget.isGauss == true) {
    //   //rootPath = Path.join(rootPath, "s/${Config.GAUSS_VALUE}");
    // }
    // rootPath = Path.join(rootPath, widget.imageUrl);
    // return rootPath;
  }

  _loadImage() async {
    _loadingFinish = false;
    if (widget.useQueue == true) {
      ImageManager.instance.loadImageInQueue(_realImageUrl,
          callback: (url, imageData) {
        _imageBase = imageData;
        if (mounted && _realImageUrl == url) {
          _loadingFinish = true;
          setState(() {});
        }
      });
    } else {
      try {
        _imageBase = await ImageManager.instance.loadImage(_realImageUrl);
        if (_imageBase != null && mounted) {
          _loadingFinish = true;
          setState(() {});
        }
      } catch (e) {
        debugLog(e.toString());
        _loadingFinish = true;
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.borderRadius != null ||
        (widget.radius != null && widget.radius != 0)) {
      return ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.radius ?? 0),
        child: _buildImage(),
      );
    }
    return _buildImage();
  }

  Widget _buildImage() {
    return (_imageBase == null)
        ? Container(
            padding: EdgeInsets.all(widget.placePadding ?? 0),
            child: widget.placeholder ?? _buildPlaceHolder(),
          )
        : SizedBox(
            width: widget.width,
            height: widget.height,
            child: Image.memory(
              _imageBase!,
              gaplessPlayback: true,
              fit: widget.fit ?? BoxFit.cover,
              errorBuilder: (context, error, track) {
                return widget.errorWidget ??
                    widget.placeholder ??
                    _buildPlaceHolder();
              },
            ),
          );
  }

  Widget _buildPlaceHolder({bool showText = false}) {

    //return CustomPlaceHolder(widget.width, widget.height);

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: const Color(0xfff7f7f7),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        "assets/svg/place.svg",
        //width: widget.width != null ? widget.width! / 4 : double.infinity,
        //height: widget.width != null ? widget.width! / 4 : double.infinity,
      ),
    );
  }
}
