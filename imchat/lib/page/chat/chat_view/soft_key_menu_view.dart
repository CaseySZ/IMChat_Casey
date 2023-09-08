import 'package:flutter/cupertino.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:imchat/page/chat/chat_view/audio_pick_view.dart';

import 'album_picker_view.dart';

class SoftKeyMenuView extends StatefulWidget {
  final double height;
  final Function(List<Media>)? pictureCallback;

  const SoftKeyMenuView({
    super.key,
    required this.height,
    this.pictureCallback,
  });

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
      padding: const EdgeInsets.only(left: 12),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          AlbumPickerView(
            callback: (imageArr) {
              if (widget.pictureCallback != null) {
                widget.pictureCallback!(imageArr);
              }
            },
            child: _buildItem("相册", "assets/images/album_key.png"),
          ),
          AudioPickerView(
            callback: (){

            },
            child: _buildItem("语音", "assets/images/5S.png"),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 35,
            height: 35,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff666262),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
