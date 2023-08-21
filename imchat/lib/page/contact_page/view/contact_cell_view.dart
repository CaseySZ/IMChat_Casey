import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/tool/image/custom_new_image.dart';

class ContactCellView extends StatefulWidget {
  const ContactCellView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContactCellViewState();
  }
}

class _ContactCellViewState extends State<ContactCellView> {
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          const SizedBox(width: 16),
          CustomNewImage(
            imageUrl: "",
            width: 40,
            height: 40,
            radius: 6,
          ),
          const SizedBox(width: 12),
          _buildStatus(true),
          const SizedBox(width: 3),
          Text("121323231", style: const TextStyle(fontSize: 16, color: Colors.black),),
        ],
      ),
    );
  }

  Widget _buildStatus(bool isOnLine) {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isOnLine ? Colors.green : Colors.yellow,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
