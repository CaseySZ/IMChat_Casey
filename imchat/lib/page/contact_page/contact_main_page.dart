import 'package:flutter/material.dart';
import 'package:imchat/page/contact_page/view/contact_cell_view.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/utils/screen.dart';

class ContactMainPage extends StatefulWidget {
  const ContactMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContactMainPageState();
  }
}

class _ContactMainPageState extends State<ContactMainPage> {
  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const SizedBox(),
        title: "通讯录",
      ),
      body: Column(
        children: [
          _buildSearch(),
          const SizedBox(height: 8),
          _buildHeadItem("assets/images/Mi.png", "新的好友", true),
          _buildHeadItem("assets/images/Uu1.png", "我的群聊", false),
          Expanded(
            child: Container(
              color: const Color(0xfff6f7fb),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ContactCellView();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

//Mi.png Uu1.png
  Widget _buildSearch() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xfff6f7fb),
            borderRadius: BorderRadius.circular(30)),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              size: 16,
              color: Color(0xff999999),
            ),
            SizedBox(width: 8),
            Text(
              "搜索好友",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff999999),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeadItem(String imagePath, String title, bool showLine) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 42,
              height: 42,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 42,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (showLine) buildLineWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
