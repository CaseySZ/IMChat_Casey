
import 'package:flutter/material.dart';

class NormalAlert extends StatelessWidget {

  static show(BuildContext context, {String? title, String? buttonTitle, String? content}) {
    showDialog(
        context: context,
        builder: (context) {
          return  NormalAlert(title: title, content: content, leftButtonTitle: buttonTitle,);
        });
  }

  final String? title;
  final String? content;
  final String? leftButtonTitle;
  const NormalAlert({super.key, this.title, this.content, this.leftButtonTitle,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: InkWell(
            onTap: () {},
            child: Container(
              width: 280,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title?.isNotEmpty == true)
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff111111),
                        ),
                      ),
                    ),
                  if (content?.isNotEmpty == true)
                    Text(
                      content!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if(leftButtonTitle?.isNotEmpty == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCancelButton(context),
                        const SizedBox(width: 16),
                        _buildSureButton(context),
                      ],
                    )
                  else
                    _buildSureButton(context),

                ],
              ),
            ),
          ),
        )
      ),
    );
  }
  Widget _buildCancelButton(BuildContext context) {
    return   InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child:   Text(
          leftButtonTitle!,
          style:  const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSureButton(BuildContext context) {
    return   InkWell(
      onTap: (){
        Navigator.pop(context, true);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const  Text(
          "确认",
          style:  TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
