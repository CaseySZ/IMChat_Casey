import 'package:flutter/cupertino.dart';
import 'package:image_pickers/image_pickers.dart';

import 'album_picker_view.dart';

class SoftKeyMenuView extends StatefulWidget {

  final double height;
  final Function(List<Media>)? pictureCallback;
  const SoftKeyMenuView({super.key, required this.height, this.pictureCallback,});



  @override
  State<StatefulWidget> createState() {
    return _SoftKeyMenuViewState();
  }
}

class _SoftKeyMenuViewState extends State<SoftKeyMenuView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.only(left: 28),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          AlbumPickerView(
            callback: (imageArr) {
              if(widget.pictureCallback != null){
                widget.pictureCallback!(imageArr);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/album_key.png",
                  width: 35,
                  height: 35,
                ),
                const SizedBox(height: 8),
                const Text(
                  "相册",
                  style: TextStyle(
                    color: Color(0xff666262),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}